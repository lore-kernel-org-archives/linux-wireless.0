Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab2CBVLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:11:52 -0500
Subject: Re: [PATCHv3 2/2] mac80211: Modify tsf via debugfs in mesh
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330722280-28879-2-git-send-email-javier@cozybit.com> (sfid-20120302_220523_367699_E139ED76)
References: <1330722280-28879-1-git-send-email-javier@cozybit.com>
	 <1330722280-28879-2-git-send-email-javier@cozybit.com>
	 (sfid-20120302_220523_367699_E139ED76)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 22:11:51 +0100
Message-ID: <1330722711.8542.26.camel@jlt3.sipsolutions.net> (sfid-20120302_221156_269804_0586DE4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 13:04 -0800, Javier Cardona wrote:

>  static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
>  {
> -	return cpu_to_le64(jiffies_to_msecs(jiffies)*1000/1024 +
> -			data->tsf_offset);
> +	struct timeval tv = ktime_to_timeval(ktime_get_real());
> +	u64 now = (u64) tv.tv_sec * MSEC_PER_SEC + tv.tv_usec / USEC_PER_MSEC;
> +	return cpu_to_le64(now + data->tsf_offset);
> +}

Oh.

But now you're giving it in MSEC, you want USEC.

johannes

