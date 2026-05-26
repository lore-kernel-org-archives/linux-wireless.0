Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC62640802D;
	Tue, 26 May 2026 17:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815672; cv=none; b=QQZ1yn0mFgQzf3dFyd427QZG/+UG+p09Hp1xLNnsfIdPVwxYUzhm7Kd7lbaik47qd54Klkyk35bviy6hJoWm9ELfbOjgsPKpEY4Es1+x/J/wbwJxWcM/GdmObSkzOixWTVTkbymAnfAk0vI7HjiQ6gA9tlcOCXn0JKxWx3fOhaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815672; c=relaxed/simple;
	bh=pVBKZTTjKnVYIsgkX1sP0itgWIRCCaZAzYFdMftMFDk=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=H/EeNNWF+DjicyNFZ0saSW0Mrr8wGKtjlJdrwDhlVrX/cdUwzKdffyIPn7pGhWjveQuvCgqS0qF5en+y+AUOxn56T/OKHFESZmwrkMzr8RihXj9xMjgttdu+56rGWhKySeZ+DrAD5qHMYLUjGrF8zHckWGD4IvhSuvaiXiP7vps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/RUX++h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/RUX++h"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8B78C1F000E9;
	Tue, 26 May 2026 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815671;
	bh=01BvEX50d1bs98mqnVQxb7uaA9htZEJOC8eRW013CR8=;
	h=Date:From:To:Cc:Subject:References;
	b=Q/RUX++hykS+Vi5lfam5+d5XGwkcNEueC7yv3oT4tUtXasYUycjVPh7zYBZdF8ZSw
	 uHl08C4ag3dpFszduUg6293PaZEG35rYC2ezuacZ8QlhNACaFvKfx2NWzuQ6GuHB1A
	 hW9ZpM+i22CIanaBxHH0MyGa0xaaVKxHzxnXpZxsJDfsAFGRykLejd86k5mprL66zY
	 WDjrE2GCF1DgZniWN/wvd2FTEZxqkBFmB6s7b8tAcfhqiSRB3M0aZdgIr0J+f1KuAD
	 W5xYdv/konHf7LzLU09NHSl6AX1b5Wod2p1b0hDrUiEXONgAqtIBQDJRVgrKoRmJ7x
	 5OKFrkLEoQDuw==
Date: Tue, 26 May 2026 19:14:28 +0200
Message-ID: <20260526171223.596169122@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
 Miroslav Lichvar <mlichvar@redhat.com>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 thomas.weissschuh@linutronix.de,
 Arthur Kiyanovski <akiyano@amazon.com>,
 Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Johannes Berg <johannes.berg@intel.com>,
 Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org,
 Takashi Iwai <tiwai@suse.com>,
 Jacob Keller <jacob.e.keller@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Peter Hilber <peter.hilber@oss.qualcomm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev,
 linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org
Subject: [patch 12/24] wifi: iwlwifi: Adopt PTP cross timestamps to core
 changes
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

iwlwifi only supports CLOCK_REALTIME timestamps and provides an incomplete
result without system counter values etc.

It also zeros struct system_device_crosststamp, which is already zeroed in
the core and initialized with the clock ID.

Remove the zeroing and reject any request for a clock ID other than REALTIME.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c |    3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -250,7 +250,8 @@ iwl_mld_phc_get_crosstimestamp(struct pt
 	/* System (wall) time */
 	ktime_t sys_time;
 
-	memset(xtstamp, 0, sizeof(struct system_device_crosststamp));
+	if (xtstamp->clock_id != CLOCK_REALTIME)
+		return -ENOTSUPP;
 
 	ret = iwl_mld_get_crosstimestamp_fw(mld, &gp2, &sys_time);
 	if (ret) {
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -160,13 +160,14 @@ iwl_mvm_phc_get_crosstimestamp(struct pt
 	/* System (wall) time */
 	ktime_t sys_time;
 
-	memset(xtstamp, 0, sizeof(struct system_device_crosststamp));
-
 	if (!mvm->ptp_data.ptp_clock) {
 		IWL_ERR(mvm, "No PHC clock registered\n");
 		return -ENODEV;
 	}
 
+	if (xtstamp->clock_id != CLOCK_REALTIME)
+		return -ENOTSUPP;
+
 	mutex_lock(&mvm->mutex);
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_SYNCED_TIME)) {
 		ret = iwl_mvm_get_crosstimestamp_fw(mvm, &gp2, &sys_time);

