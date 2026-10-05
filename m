Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B6F1C5D72;
	Mon,  5 Oct 2026 05:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791177346; cv=none; b=P28XjRPOa5NHjdftOsh75Bdq6WUsQsqyYoboWgwszcgTqE8GxfrSEU4OdYpr4PCqhGNlv6Q/L2E+9xHTvvZsuiYUDCkJ1Zf/YCfYW9atEnF7jGDr2X/QMqiejxISwkA94fK1KwutfJGCtfU6PhYQ+CMdrwpk/++X2wHvr+1CeeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791177346; c=relaxed/simple;
	bh=kOuaYwHDPsmrTlYd6BpmCuKdfr/VssQfAMHxWg7APIM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BlqA6riheu1VCsHZzPPJ1H/3XxEwAJyILUAPCgW/82q+t7WAkrXAEzistHrENT3QeRxKO32Cz3bIemXXAraFQS2BAB7yn8qCw2iSrtBw4idodptFv/zYFpyUZtqAkLruI2ZVFKkwCPZ4DjV+FuA67MwZJ/BDfFNYgDdsc4HYI1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T90hqljW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T90hqljW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B933D1F00893;
	Mon,  5 Oct 2026 05:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791177345;
	bh=vI2L2IdWYNR2YLuRfjHjIVlGOZSCK0icCZA3G/XtY4k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T90hqljW4iuHIVtMmjkEvBV2RPMrGNc0yESbZvyhgQ72MV2+qV/lpsoUEDlUV9zr8
	 2+M+RUvp31hiPEJMrcueKcpniVJreZEZ/rR8SHy5uZhgFQMORTlgqTBO8d7y1+Mhdc
	 EvjBqD8Oiw5hM+lYi25qwP9i1SMjP0SgEVs1gLwWotInzqWO69Bvf5ekmEXr1uVTyA
	 Cu8V6RbjX3zTvJj51NRI3SskPifrmwYZKMLKKZd2X003oUgPnMzaiqsKPQuOU9ictt
	 9PakPDTfmQdfGlQTdlbvP7kCxMhORM3H2mG/JOFGU4J2n7L6i51/jYha/FGXh3TANY
	 Uz3TYAQsOdfFw==
Subject: Re: [PATCH v2 2/2] wifi: iwlwifi: mld: Fix GP2 to nanoseconds
 overflow on 32-bit
From: netdev-bot+sashiko@kernel.org
To: zhanxusheng1024@gmail.com
Cc: miriam.rachel.korenblit@intel.com, johannes@sipsolutions.net,
 daniel.gabay@intel.com, emmanuel.grumbach@intel.com, avraham.stern@intel.com,
 gregory.greenman@intel.com, richardcochran@gmail.com,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com, kuba@kernel.org
Date: Mon, 05 Oct 2026 05:15:44 +0000
Message-ID: <179117734433.434549.1705345801054680829@kernel.org>
In-Reply-To: <20261001050103.860584-3-zhanxusheng@xiaomi.com>
References: <20261001050103.860584-3-zhanxusheng@xiaomi.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete: one u32 GP2 × NSEC_PER_USEC
  multiplication in the mld driver is still unfixed.
- [Low] The commit message is inaccurate and incomplete.

--

wifi: iwlwifi: mld: Fix GP2 to nanoseconds overflow on 32-bit

This patch adds u64 casts to two u32 GP2 * NSEC_PER_USEC multiplications
in the iwlmld PTP code: one in iwl_mld_ptp_get_adj_time() and one in
iwl_mld_ptp_adjfine(). Without the casts, 32-bit kernels compute the
product in 32 bits, and it truncates for GP2 values above about 4.295
seconds.

> iwl_mld_ptp_gettime() and iwl_mld_ptp_get_crosstimestamp() in the same
> file already cast to u64 before multiplying.  Do the same here.

[Severity: Low]
This isn't a bug, but mld/ptp.c has no function called
iwl_mld_ptp_get_crosstimestamp(). Is this meant to be
iwl_mld_phc_get_crosstimestamp()?

The message also describes only the scale_time_gp2_ns line in
iwl_mld_ptp_get_adj_time(). It doesn't mention the second hunk, which
changes the gp2 * NSEC_PER_USEC argument in iwl_mld_ptp_adjfine().

Could the message cover both sites, and the user-visible effect, as the
mvm companion patch does?

> diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
> index 1ac85d6ce1d79..41ba49f525845 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
> @@ -59,7 +59,8 @@ static void iwl_mld_ptp_update_new_read(struct iwl_mld *mld, u32 gp2)
>  u64 iwl_mld_ptp_get_adj_time(struct iwl_mld *mld, u64 base_time_ns)
>  {
>  	struct ptp_data *data = &mld->ptp_data;
> -	u64 scale_time_gp2_ns = mld->ptp_data.scale_update_gp2 * NSEC_PER_USEC;
> +	u64 scale_time_gp2_ns = (u64)mld->ptp_data.scale_update_gp2 *
> +				NSEC_PER_USEC;

[Severity: High]
Does one more caller of iwl_mld_ptp_get_adj_time() have the same
truncation? In mld/rx.c, the monitor mode PTP timestamp path in
iwl_mld_rx_fill_status() still does this:

drivers/net/wireless/intel/iwlwifi/mld/rx.c:iwl_mld_rx_fill_status() {
    ...
		if (mld->monitor.ptp_time) {
			u64 adj_time =
				iwl_mld_ptp_get_adj_time(mld,
							 phy_data->gp2_on_air_rise *
							 NSEC_PER_USEC);
    ...
}

gp2_on_air_rise is a u32 in struct iwl_mld_rx_phy_data. On 32-bit, this
multiplication wraps before the result is widened to the u64 argument.

The mvm companion patch, "wifi: iwlwifi: mvm: Fix GP2 to nanoseconds
overflow on 32-bit", casts the matching gp2_on_air_rise site in
iwl_mvm_rx_fill_status().

The truncated value also reaches the shared wraparound tracking, because
iwl_mld_ptp_get_adj_time() does:

	iwl_mld_ptp_update_new_read(mld,
				    div64_u64(base_time_ns, NSEC_PER_USEC));

For example, take gp2_on_air_rise = 10,000,000 us. After the 32-bit wrap
the product is 1,410,065,408 ns, which divides back to 1,410,065 us.

If last_gp2 is around 10,000,000, the gap is larger than
IWL_PTP_WRAP_THRESHOLD_USEC. iwl_mld_ptp_update_new_read() then treats
the frame as a wraparound: it increments wrap_counter and overwrites
last_gp2.

Wouldn't that shift the PHC by 2^32 us for gettime64, adjfine and the
other PTP users, not just the radiotap mactime?

The path can be hit on 32-bit builds with CONFIG_IWLWIFI_DEBUGFS, monitor
mode on, and the rx_ts_ptp debugfs knob set.

Should the rx.c call get the same (u64) cast in this patch?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261001050103.860584-1-zhanxusheng%40xiaomi.com
