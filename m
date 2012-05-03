Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2847 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab2ECGMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 02:12:16 -0400
Message-ID: <4FA221A2.10701@broadcom.com> (sfid-20120503_081220_355054_DACFBA43)
Date: Thu, 3 May 2012 08:11:46 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Nathan Hintz" <nlhintz@hotmail.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Kalle Valo" <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	hauke@hauke-m.de
Subject: Re: [PATCH v2 0/6] BCMA Cumulative patches from OpenWRT
References: <BLU0-SMTP45859B1CA3415BE44C9024CAC240@phx.gbl>
 <4F990DC1.4070305@broadcom.com> <87r4vaaezl.fsf@purkki.adurom.net>
 <20120502181157.GC9285@tuxdriver.com> <4FA182A8.8080604@broadcom.com>
 <BLU0-SMTP243D8B9F11F7BC3D5419A97AC2F0@phx.gbl>
In-Reply-To: <BLU0-SMTP243D8B9F11F7BC3D5419A97AC2F0@phx.gbl>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 07:04 AM, Nathan Hintz wrote:
> I will repost; it will probably be a few days though.  I haven't used
> GIT before other than cloning some repo's, so I have a learning curve to
> overcome.
> 
> Any hints are welcome.
> 
> Thanks,
> Nathan

Adding a description to a change is not a git specific thing, but a scm
best-practice. To easily add a description to each of your patches is by
doing an interactive rebase (details in [1]).

$ git rebase -i HEAD~6
* this will pop-up your favorite editor
* each line starts with word 'pick'
* replace it with letter 'r'
* close the editor

git will open the editor for each change and let you enter a
description. After that you can recreate your patches.

$ git format-patch --subject-prefix="PATCH v3" --cover-letter -s -M -6

I always give the -M to catch renames and -s to add signed-off-by.

Hope this helps.

Gr. AvS

[1] http://book.git-scm.com/4_interactive_rebasing.html

