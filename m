Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DB454655;
	Mon,  5 Oct 2026 05:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791177345; cv=none; b=W542Wz2Zp7x4VZCzu4pKwBo9J8qVqJ1XBDijywvNMI2dYRHeT1ojul7pYrqLp3vqnRvudX7bgySZYh2CkzZ5FF5bMWDyAy79sip82t5Hyjb6rq1TVIugtqqU27Y14hI6PQM94cQtTCX2ErhKQf3GKqcTzU6MDBfz0Nd98WTVuYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791177345; c=relaxed/simple;
	bh=wBKKtdP1U2i5bT1lgkF8LwfLVu0mNU/DPA0qArx6/54=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OAosAVbKdtzq5VvsyatwKWTAoSxoIcAaatg0zSis1v4GrUbxHSIRhLpBPFUywfZUmTPmtUHuEpA+YSdVEfh4j3x6+FfziQu+OZH9OOaKykNIJY3Zfc8PWgfqYj7ADsCOHSW64aJX5i2DlH71c+D1tBI62pmLzK8jN6zocf6sdAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zwza98Tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zwza98Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D0C1F000FF;
	Mon,  5 Oct 2026 05:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791177344;
	bh=hj/9G5bzfkiZv3U07vY05CzjC1JwCGbdlPhimH0cuRA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Zwza98Tcj/Vmr+Wgqtr07+70y5763OnxmBTSV2hK3CkS+0bjMtdYfwlMx32FSJ0nN
	 Al6ylucFDJ5vc5w7nuF0nRzpOvI4fZus+xG7V3nmSPxDLQdQ7ipHdQLB+6KPFphSyT
	 0uTAwEp6j0hLhe8ycrrzR+HoyxM+Qm3wxCeqY/YpE3FWOerJGaEh6+Upbjvk+th7wm
	 3nT/6Jp0vmqAcsCO9s6fgOZ+047Pk85j+5v3S6xC0gvqFQNIZpthGlnQ/S+Fh3gVmV
	 QjqXoKQH0viL7oJvqi5P6dm4KUQxyMGyJux6su+BVvaTe/sQdIgDlkoPG1FVy3+PO/
	 4iMJL5TTWwnSQ==
Subject: Re: [PATCH v2 1/2] wifi: iwlwifi: mvm: Fix GP2 to nanoseconds
 overflow on 32-bit
From: netdev-bot+sashiko@kernel.org
To: zhanxusheng1024@gmail.com
Cc: miriam.rachel.korenblit@intel.com, johannes@sipsolutions.net,
 daniel.gabay@intel.com, emmanuel.grumbach@intel.com, avraham.stern@intel.com,
 gregory.greenman@intel.com, richardcochran@gmail.com,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com, kuba@kernel.org
Date: Mon, 05 Oct 2026 05:15:43 +0000
Message-ID: <179117734302.434549.2056296312989341685@kernel.org>
In-Reply-To: <20261001050103.860584-2-zhanxusheng@xiaomi.com>
References: <20261001050103.860584-2-zhanxusheng@xiaomi.com>
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

Critical: 0 · High: 1 · Medium: 0 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The series fix is incomplete for the mld op-mode.
- [Low] The commit author (From:) is `Zhan Xusheng
  <zhanxusheng1024@gmail.com>`, but the only Signed-off-by is `Zhan…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but in mvm the
  shared PTP state in mvm->ptp_data (last_gp2, wrap_counter,…

--

wifi: iwlwifi: mvm: Fix GP2 to nanoseconds overflow on 32-bit

This patch casts the u32 GP2 microsecond timestamps to u64 before they are
multiplied by NSEC_PER_USEC. The affected functions are
iwl_mvm_ptp_get_adj_time(), iwl_mvm_ptp_adjfine() and
iwl_mvm_rx_fill_status().

On 32-bit kernels these products were computed in 32 bits. They wrapped
for GP2 values above about 4.295 s, which made the PTP clock jump.

> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

[Severity: Low]
This isn't a bug, but the author address (zhanxusheng1024@gmail.com) is
different from the Signed-off-by address (zhanxusheng@xiaomi.com).
checkpatch reports this as a From:/Signed-off-by: email address mismatch.

Could a Signed-off-by be added for the gmail address? Another option is a
From: line with the xiaomi address in the patch body. The follow-up mld
commit in this series has the same mismatch.

> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
> index 49dcb1388007b..5f33e2f8fb2a9 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c

[ ... ]

> @@ -259,7 +259,7 @@ static int iwl_mvm_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>  	 */
>  	gp2 = iwl_mvm_get_systime(mvm);
>  	data->scale_update_adj_time_ns =
> -		iwl_mvm_ptp_get_adj_time(mvm, gp2 * NSEC_PER_USEC);
> +		iwl_mvm_ptp_get_adj_time(mvm, (u64)gp2 * NSEC_PER_USEC);
>  	data->scale_update_gp2 = gp2;
>  	data->wrap_counter = 0;
>  	data->delta = 0;

[Severity: Medium]
This is a pre-existing issue, and this patch did not introduce it. Is
mvm->ptp_data safe from concurrent readers here?

iwl_mvm_ptp_adjfine() updates scale_update_adj_time_ns, scale_update_gp2,
wrap_counter and delta while holding only mvm->mutex.

Some RX paths call iwl_mvm_ptp_get_adj_time() without taking any lock:

  iwl_mvm_rx_fill_status()                (NAPI, rx_ts_ptp && monitor_on)
  iwl_mvm_time_sync_msmt_event()          (RX_HANDLER_SYNC)
  iwl_mvm_time_sync_msmt_confirm_event()  (RX_HANDLER_SYNC)

That function also changes state through iwl_mvm_ptp_update_new_read():

	if (gp2 < mvm->ptp_data.last_gp2) {
		mvm->ptp_data.wrap_counter++;
		...
	}

	mvm->ptp_data.last_gp2 = gp2;

The writers that hold mvm->mutex are iwl_mvm_ptp_adjfine(),
iwl_mvm_ptp_adjtime(), iwl_mvm_ptp_work(), iwl_mvm_ptp_gettime() and
iwl_mvm_phc_get_crosstimestamp(). That mutex does not keep out softirq RX
on other CPUs.

These interleavings look possible:

- RX sees the new scale_update_gp2 before wrap_counter is reset to 0, so
  the timestamp is off by N * 2^32 us.

- Two RSS queues both run the non-atomic wrap_counter++ / last_gp2
  update, so a wrap is counted twice or lost.

- On 32-bit, the u64 fields scale_update_adj_time_ns, scaled_freq and
  delta can tear while adjfine or adjtime writes them.

The mld driver protects the same state with data->lock, using
spin_lock_bh() in mld/ptp.c. Does mvm need similar locking?

> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> index 7f0b4f5daa214..7a9a63a76f382 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> @@ -2017,7 +2017,9 @@ static void iwl_mvm_rx_fill_status(struct iwl_mvm *mvm,
>  
>  	if (mvm->rx_ts_ptp && mvm->monitor_on) {
>  		u64 adj_time =
> -			iwl_mvm_ptp_get_adj_time(mvm, phy_data->gp2_on_air_rise * NSEC_PER_USEC);
> +			iwl_mvm_ptp_get_adj_time(mvm,
> +						 (u64)phy_data->gp2_on_air_rise *
> +						 NSEC_PER_USEC);

[Severity: High]
Does the mld op-mode still have this overflow in its RX path?

The follow-up commit "wifi: iwlwifi: mld: Fix GP2 to nanoseconds overflow
on 32-bit" says it fixes the "Same problem as the mvm driver". However, it
only changes the two sites in mld/ptp.c, in iwl_mld_ptp_get_adj_time() and
iwl_mld_ptp_adjfine().

At the end of the series, iwl_mld_rx_fill_status() in mld/rx.c still has
no cast:

drivers/net/wireless/intel/iwlwifi/mld/rx.c:iwl_mld_rx_fill_status() {
    ...
		if (mld->monitor.ptp_time) {
			u64 adj_time =
				iwl_mld_ptp_get_adj_time(mld,
							 phy_data->gp2_on_air_rise *
							 NSEC_PER_USEC);
    ...
}

gp2_on_air_rise is a u32 in struct iwl_mld_rx_phy_data, and NSEC_PER_USEC
is 1000L. On 32-bit the product therefore wraps for any GP2 value above
about 4,294,967 us.

The truncated value is then passed to iwl_mld_ptp_update_new_read() as a
small gp2. It is usually more than IWL_PTP_WRAP_THRESHOLD_USEC below
last_gp2, so it looks like a wraparound:

		mld->ptp_data.wrap_counter++;

This would happen each time the truncated value wraps. It would also
happen each time gettime or crosstimestamp stores a correct, large
last_gp2.

That would make rx_status->mactime wrong. It would also shift later
iwl_mld_ptp_gettime() results by 2^32 us for each spurious wrap.

IWLMLD does not depend on 64BIT, and this path is reachable with the
rx_ts_ptp debugfs knob and a monitor interface. Should the mld follow-up
also cast gp2_on_air_rise to u64 in iwl_mld_rx_fill_status()?

>  
>  		rx_status->mactime = div64_u64(adj_time, NSEC_PER_USEC);
>  		rx_status->flag |= RX_FLAG_MACTIME_IS_RTAP_TS64;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261001050103.860584-1-zhanxusheng%40xiaomi.com
