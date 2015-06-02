Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbFBBZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 21:25:07 -0400
Date: Tue, 2 Jun 2015 10:25:04 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	stable@vger.kernel.org, sw@simonwunderlich.de
Subject: Re: [PATCH] ath9k: Prevent radard detection and spectral scan to be
 used concurrently
Message-ID: <20150602012504.GC23370@kroah.com> (sfid-20150602_032511_755389_01EF00CC)
References: <1433182357-17405-1-git-send-email-benjamin@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433182357-17405-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 01, 2015 at 08:12:37PM +0200, Benjamin Berg wrote:
> In the case that a spectral scan is enabled the PHY errors sent by the
> hardware as part of the scanning might trigger the radar detection and
> channels might be marked as 'unusable' incorrectly. This patch fixes
> the issue by preventing the spectral scan to be enabled if DFS is used
> and only analysing the PHY errors for DFS if radar detection is enabled.
> 
> Reported-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> 
> [v3.19+]
> ---
> 
> The patch does apply to 3.19+ with a bit of fuzz.
> 
> 
>  drivers/net/wireless/ath/ath9k/common-spectral.c | 4 ++++
>  drivers/net/wireless/ath/ath9k/main.c            | 6 ++++++
>  drivers/net/wireless/ath/ath9k/recv.c            | 7 +++++--
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
