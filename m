Received: from mail.schwarzvogel.de (skade.schwarzvogel.de [157.90.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E5F2E54D1
	for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2026 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=157.90.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771427046; cv=none; b=Gxx0nQGUguYfap1FPdMRev5og7nP6VwPXEXNW7dQoXmX5KU3JaB5GvOZ4D56NsYwVY2Mu1+VwzISPuURr9O4j/ukbxEjbH3fliow7xCG3aQzfHOcCYt3Nf3jp//4NqXyDbg11FAokfv69nSZxVMTal/kumGXL+avJ4uD8THKqSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771427046; c=relaxed/simple;
	bh=XLmaV1VWsEdYflUZJ55m9EgSRwnjw9RAS6n9uFx+1ik=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MChQPmrvJouNz+3wzLbyZML7q7yoXVkMrMkWTq6uOmMv7NjoL2+W5/dsh3C23R6WmoXDcuWRREVxIOK16jhdHy7rYKgbNaJwbWpr4VDqgjJ2hNGbZjSF8qeiPLjtt8GuecX30HOSYnXoW/1UCgdjuOgSRDOemSUUeC0xgQMyb5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schwarzvogel.de; spf=pass smtp.mailfrom=schwarzvogel.de; dkim=pass (2048-bit key) header.d=schwarzvogel.de header.i=@schwarzvogel.de header.b=AfreFwwc; arc=none smtp.client-ip=157.90.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schwarzvogel.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwarzvogel.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwarzvogel.de header.i=@schwarzvogel.de header.b="AfreFwwc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=schwarzvogel.de; s=x; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:In-Reply-To:References;
	bh=Q3i2NQ1GOEbcXYOfECZ+MIHuf5oUDxbyhNUxa+XR/1g=; b=AfreFwwcGLJQBFHIxKkfRgwXTk
	1/u/C4zrrrWXb89jKptsBev+4Z8vYfzfN1YKIoNlOsu34ML1N7tFj3Wj30g0sN/ilL+LUTSTCtZ3n
	BcyhXIo7pKM6epkQ+x0h6o1UkouCJGWxCiIVhcJFgBrTtp3cauCY6hjsznbLCuI3I54zC+n91GSst
	hUMT1ErOKJTnKq65QC2v+axiuQGvzVRhnrAT9CH3zW67F3TKPdJdrZJ0Ma1CZYlTv4nF5HtvsDCqk
	8U0MMEpMuILKe3R/YXNNBzA+o0k0mg+DweXwxRKh4hOFf7DcKuTzvVDKLwDWIP+pU7+vAWjcu/1/k
	FCa4X2wQ==;
Received: from klausman by mail.schwarzvogel.de with local (Exim 4.99.1)
	(envelope-from <klausman@schwarzvogel.de>)
	id 1vsizT-00000000Gk1-3OVs;
	Wed, 18 Feb 2026 15:57:23 +0100
Date: Wed, 18 Feb 2026 15:57:23 +0100
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: iwlwifi: "Unandled alg" should be squelched or improved
Message-ID: <ee8db85f-a9b9-41d9-b225-e9b18ba59ec9@skade.local>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

at the moment, there are two places in the iwlwifi driver that produce
"Unhandled alg" messages:

drivers/net/wireless/intel/iwlwifi/mvm/rx.c:

static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm, ...) {
      [...]
      switch (rx_pkt_status & RX_MPDU_RES_STATUS_SEC_ENC_MSK) {
	  [...]
      default:
          /* Expected in monitor (not having the keys) */
          if (!mvm->monitor_on)
              IWL_WARN(mvm, "Unhandled alg: 0x%x\n", rx_pkt_status);
      }

	  return 0;
}

and drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:

static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm,...) {
      [...]
      switch (status & IWL_RX_MPDU_STATUS_SEC_MASK) {
      [...]
      default:
          /*
           * Sometimes we can get frames that were not decrypted
           * because the firmware didn't have the keys yet. This can
           * happen after connection where we can get multicast frames
           * before the GTK is installed.
           * Silently drop those frames.
           * Also drop un-decrypted frames in monitor mode.
           */
          if (!is_multicast_ether_addr(hdr->addr1) &&
              !mvm->monitor_on && net_ratelimit())
              IWL_WARN(mvm, "Unhandled alg: 0x%x\n", status);
      }

      return 0;
}

This results in message in kmsg like:

[   16.972247] iwlwifi 0000:01:00.0: Unhandled alg: 0x4000707

These messgaes are not really actionable (they don't even log what the
origin for the packets is), and even for competent sysadmins, are at
best opaque as to what is going on.

As a result, there are various "fixes" mentioned on the web that do
stuff like adding swcrypto=0 to the module options, which seems
ill-advised to me.

So I think that they should not be emitted by default. I tried switching
them ot IWL_INFO (hoping that at INFO level, nothing is logged by
default), but alas, that makes no real difference in the default setup.

I would have sent along a patch that just drops them, but they're both
sitting in default branches of switch statements, and it feels vaguely
wrong to have empty or nonexistent default sections, so I am unsure what
the right thing to do here would be. Plus, the second file has an
explanatory comment that would have nowhere to go.

Best,
Tobias

PS: I am not subscribed to linux-wireless@, so pleas CC me on replies
there. Thanks!

-- 
Sent from aboard the Culture ship
	GCU Sacrificial Victim
