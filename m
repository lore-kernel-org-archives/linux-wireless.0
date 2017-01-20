Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751982AbdATNUw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 08:20:52 -0500
Date: Fri, 20 Jan 2017 14:16:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v3] rt2x00: rt2800lib: add support for RT3352 with 20MHz
 crystal
Message-ID: <20170120131609.GA21564@redhat.com> (sfid-20170120_142055_566168_A4282066)
References: <20170118142958.GA14573@redhat.com>
 <20170119234239.GA22196@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170119234239.GA22196@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel

On Fri, Jan 20, 2017 at 12:42:44AM +0100, Daniel Golle wrote:
> +int rt2800_probe_clk(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	struct clk *clk = clk_get(rt2x00dev->dev, NULL);
> +
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	if (clk_get_rate(clk) == 20000000)
> +		spec->clk_is_20mhz = 1;
> +
> +	return 0;
> +}
> +
>  int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
>  	int retval;
> @@ -7864,6 +7903,15 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
>  	rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
>  
>  	/*
> +	 * Probe SoC clock.
> +	 */
> +	if (rt2x00_is_soc(rt2x00dev)) {
> +		retval = rt2800_probe_clk(rt2x00dev);
> +		if (retval)
> +			return retval;
> +	}
<snip>
> @@ -415,6 +416,7 @@ struct hw_mode_spec {
>  	const struct channel_info *channels_info;
>  
>  	struct ieee80211_sta_ht_cap ht;
> +	int clk_is_20mhz;

I dislike adding this variable to structure that is intended to describe
wireless capabilities. Additionally we do not actually "probe" the
clock but just read it value from rt2x00dev->dev, this can be handled
better. I'll post different patch reading clk and on top of if this
patch and "add support for RT5350 WiSoC" .

Regards
Stanislaw
