Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38776 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934130AbeF0PiA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:38:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] mt76x2: dfs: add sw event ring buffer
References: <20180616155621.30539-3-lorenzo.bianconi@redhat.com>
Date: Wed, 27 Jun 2018 18:37:57 +0300
In-Reply-To: <20180616155621.30539-3-lorenzo.bianconi@redhat.com> (Lorenzo
        Bianconi's message of "Sat, 16 Jun 2018 17:56:19 +0200")
Message-ID: <878t709r56.fsf@purkki.adurom.net> (sfid-20180627_173804_866370_656B97F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Introduce sw event ring buffer to queue DFS pulses loaded from the hw.
> Radar pulses will be used in DFS sw detector
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[...]

> +static bool mt76x2_dfs_fetch_event(struct mt76x2_dev *dev,
> +				   struct mt76x2_dfs_event *event)
> +{
> +	u32 i, data[4];
> +
> +	for (i = 0; i < ARRAY_SIZE(data); i++) {
> +		/* 1st: DFS_R37[31]: 0 (engine 0) - 1 (engine 2)
> +		 * 2nd: DFS_R37[21:0]: pulse time
> +		 * 3rd: DFS_R37[11:0]: pulse width
> +		 * 3rd: DFS_R37[25:16]: phase
> +		 * 4th: DFS_R37[12:0]: current pwr
> +		 * 4th: DFS_R37[21:16]: pwr stable counter
> +		 *
> +		 * 1st: DFS_R37[31:0] set to 0xffffffff means no event detected
> +		 */
> +		data[i] = mt76_rr(dev, MT_BBP(DFS, 37));
> +	}
> +
> +	if (data[0] == GENMASK(31, 0))
> +		return false;
> +
> +	event->engine = (data[0] & BIT(31)) ? 2 : 0;
> +	event->ts = data[1] & GENMASK(21, 0);
> +	event->width = data[2] & GENMASK(11, 0);

No magic values and that data[2] stuff, please. Instead create a proper
struct and defines for the GENMASKs.

-- 
Kalle Valo
