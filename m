Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B44418F2;
	Tue, 26 May 2026 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815711; cv=none; b=kufLZPo+7V5mOGAepJ/YNyn2VprjJ7YGzNZaKAiRDc0vm91b1rfZbBIKrn6Wd73NeUEhuyrYQON7kPmL7ALbN21dV7zAm7bg+1HGzSi6+7IwLnBZYW6CAymn/an73OigcWknysE4W8vP7b60kXCL2dVBfUh7nAcsUrzpNGlWO9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815711; c=relaxed/simple;
	bh=qh5z+Kg4oYjCDXalalq6sHc/U8ocIHbVTF4h/qc9+B8=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=DgYLMI8yRgC+u/pq1JZZIiPB7s0bcTRBP2f+iA90AQGQ8Tknn0/kw93KNTmvFK/d3D7DMOGaZ+XVJpfU2NnADsBEwEZeohiWRHvQgEiatFDLUrrTu0IBtpOLCjcxWRd49/ZUZ+QKdD6kes+azsb2qlo1N1nUDEHTfVgjrOJtonY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2+QOl03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2+QOl03"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C0E941F000E9;
	Tue, 26 May 2026 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815710;
	bh=bsO9xMrbXYOi+1ANV8/URAy8a3Pmb8c0uBje1sYfZ9g=;
	h=Date:From:To:Cc:Subject:References;
	b=j2+QOl03ERWXbt5Z+hlyvh94yVW+Ys+40SNeWcbnagjaX3tIYaNkHsLmkAtWrFX8a
	 f+0Lxxsf3D5OCJxQ6Q3OQUpUUMyO7HC/qeAP/ztG4yE6Lxa42y36SA76uFQud5Moje
	 z5SJdNwnh1PgVHwZE1M+DwN+3hUYBiUmav0R+NL8nXEkPKkLM4wP2KklGWRFzv6DDK
	 zfKiGksrg9sjbNWfUI7lXhe2Cas5loIDkfoEbwxsDGvRIPC8PZq6MXqRNoMZAl72ku
	 Bc1F1/rzk2xfeRmp5aDw5FzqgOJW/bVG8M9OkVOygGT8a7YCz+j9kXyvh/p0DIZ8Ih
	 go6415IeZ8nmQ==
Date: Tue, 26 May 2026 19:15:07 +0200
Message-ID: <20260526171224.198945692@kernel.org>
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
 linux-wireless@vger.kernel.org,
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
 linux-sound@vger.kernel.org
Subject: [patch 20/24] wifi: iwlwifi: Use
 system_device_crosststamp::sys_systime
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

sys_systime is an alias for sys_realtime. The latter will be removed so
switch the code over to the new naming scheme.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -271,7 +271,7 @@ iwl_mld_phc_get_crosstimestamp(struct pt
 
 	/* System monotonic raw time is not used */
 	xtstamp->device = ns_to_ktime(gp2_ns);
-	xtstamp->sys_realtime = sys_time;
+	xtstamp->sys_systime = sys_time;
 
 	return ret;
 }
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -185,7 +185,7 @@ iwl_mvm_phc_get_crosstimestamp(struct pt
 
 	/* System monotonic raw time is not used */
 	xtstamp->device = (ktime_t)gp2_ns;
-	xtstamp->sys_realtime = sys_time;
+	xtstamp->sys_systime = sys_time;
 
 out:
 	mutex_unlock(&mvm->mutex);

