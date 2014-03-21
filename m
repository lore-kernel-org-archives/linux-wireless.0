Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30319 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760774AbaCUQZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 12:25:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: add the Rx rate in FW stats
References: <1395396014-24631-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQ=X=UxikrVrmr3hyQgjN2Tg5aeW5Ok7b+23n9X6bxRshA@mail.gmail.com>
Date: Fri, 21 Mar 2014 18:25:09 +0200
In-Reply-To: <CA+BoTQ=X=UxikrVrmr3hyQgjN2Tg5aeW5Ok7b+23n9X6bxRshA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 21 Mar 2014 12:02:06 +0100")
Message-ID: <87a9cja596.fsf@kamboji.qca.qualcomm.com> (sfid-20140321_172523_580919_A21BCCED)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The main problem here is there are subtle yet crazy binary
> incompatibilities between these firmwares.
>
> The best way would probably be to implement wmi as an abstraction
> layer with completely different backends for different firmware
> branches/revisions. Otherwise you sign up for some pain..

Yeah, I'm starting to believe that we will need something like that.
Other option is just to duplicate wmi.c and wmi.h for each interface
version. More code, but we get to keep more hair ;)

But we need to talk a lot more about this. For this patch in question we
should be able to manage with the current method of handling
differences.

-- 
Kalle Valo
