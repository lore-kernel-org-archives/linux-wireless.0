Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:7539 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3H0G4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 02:56:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: initial per-VDEV FW statistics implementation
References: <1377516815-12660-1-git-send-email-bartosz.markowski@tieto.com>
Date: Tue, 27 Aug 2013 09:56:31 +0300
Message-ID: <87txibmxk0.fsf@kamboji.qca.qualcomm.com> (sfid-20130827_085640_511822_FDC61B9F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> FW 1.0.0.716 brings per-VDEV statistics. This patch-set implements
> debugfs mechanism to fetch those. There's still few more fileds we
> can read from the FW stats event, which are not covered here.
>
> Please note there's an ABI change in wmi_peer_stats structure, hence
> the PEER statistics will be corrupted if used with older firmware
> (e.g. 1.0.0.636)

We need to support the older firmware, so please add a feature flag VDEV
statistics so that we can detect which version of the struct needs to be
used.

Also I think you can fold patches 1 and 2.

-- 
Kalle Valo
