Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35867 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbbEUFkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 01:40:40 -0400
Received: by wizk4 with SMTP id k4so1967546wiz.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 22:40:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431434736-7077-1-git-send-email-michal.kazior@tieto.com>
References: <1431434736-7077-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 21 May 2015 07:40:38 +0200
Message-ID: <CA+BoTQ=dzJS447Gx+XAXPT6gZDDKZ__6scbxe0QC-iMA47bZmQ@mail.gmail.com> (sfid-20150521_074043_368200_1339F8D6)
Subject: Re: [PATCH] amth10k: fix promisc handling
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 May 2015 at 14:45, Michal Kazior <michal.kazior@tieto.com> wrote:
> Patch df1404650ccb ("mac80211: remove support for
> IFF_PROMISC") removed promiscuous flag propagation
> to drivers.
>
> However the patch was designed against ath10k
> without 548462133d98 ("ath10k: fix interrupt
> storm").
>
> After merge the code drifted into being no longer
> correct and due to monitor vdev being
> overzealously started caused IBSS to crash on
> 999.999.0.636 for QCA988X (this firmware revision
> is known to have issues with monitor vdev).
>
> This patch keeps expectations of commit
> 548462133d98 (i.e. reduce irq storm by not
> enabling monitor vdev for AP) and doesn't break
> existing (known) setups that imply promiscuous
> mode on network interfaces.
>
> Contrary to what it looks like 548462133d98
> functionality is not reverted since the intention
> was a subset of what df1404650ccb did.
>
> Fixes: c17c997d5613 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Apparently this also fixes some weird issues with qca6174 hw2.1 notably:
 - ath10k causing disconnecting of other devices in a BSS
 - random Fw crashes

Both problems started to happen because c17c997d5613 enabled monitor
vdev by default on STA interfaces. It seems that qca6174 hw2.1
firmware has issues similar to those of qca988x 999.999.0.636
regarding monitor vdev opration.

Also, I've made a typo in the subject.

I'll post v2 with subject fixed and extended commit log later.


Michał
