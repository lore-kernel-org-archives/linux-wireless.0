Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40013 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaJEPnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2014 11:43:02 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21553.26426.635879.645561@gargle.gargle.HOWL> (sfid-20141005_174306_702764_1BD70A82)
Date: Sun, 5 Oct 2014 21:13:54 +0530
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFT] iwlwifi: dvm: drop non VO frames when flushing
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B53BCEA@hasmsx107.ger.corp.intel.com>
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
	<21553.24219.336858.538019@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B53BCEA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grumbach, Emmanuel wrote:
> I can't really tell... I guess it depends on the firmware / hardware. On these
> devices (dvm), the firmware would take a very long time to send / drop the
> packets. I guess it is a bug, and users have been suffering from this for a
> very long time. Thing is that I was educated by the "Thee shall not drop
> packets" mantra. But it appears that sometimes, it is very healthy to drop
> packets to solve the traffic jam. Here, I just drop the packets besides the VO
> queue to allow the roaming mgmt frames to reach their goal (I rely on the fact
> that the VO queue will not be too large...).

Ok.

ath9k does have a timeout, so we drain (drop) all pending frames if flushing
doesn't complete within a reasonable time.

Sujith
