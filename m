Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:45643 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaCUOW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 10:22:59 -0400
Received: by mail-ve0-f169.google.com with SMTP id pa12so2669845veb.28
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 07:22:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=X=UxikrVrmr3hyQgjN2Tg5aeW5Ok7b+23n9X6bxRshA@mail.gmail.com>
References: <1395396014-24631-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQ=X=UxikrVrmr3hyQgjN2Tg5aeW5Ok7b+23n9X6bxRshA@mail.gmail.com>
Date: Fri, 21 Mar 2014 22:22:59 +0800
Message-ID: <CAEFj987cTdr_7bhMajp2fRK5y1WAy0icyUJcTWSahW5sGFAFWQ@mail.gmail.com> (sfid-20140321_152314_340730_26B943A5)
Subject: Re: [PATCH] ath10k: add the Rx rate in FW stats
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Unfortunately this isn't as simple as it seems.
>
> Stats are received via wmi_stats_event. This structure contains fields
> describing number of pdev/vdev/beer/bcn stat entries. All entries
> (structures) are appended in certain order after this header. This
> means if you change length of structure type you skew the calculation
> of all succeeding entries.
>
> IOW this means this patch breaks peer stats for 999.999.0.636.
>
> I'm quite positive wmi_pdev_stats is also broken. This implies vdev
> stats and peer stats position calculation is skewed in the first place
> and you get garbage.
>
> The main problem here is there are subtle yet crazy binary
> incompatibilities between these firmwares.
>
> The best way would probably be to implement wmi as an abstraction
> layer with completely different backends for different firmware
> branches/revisions. Otherwise you sign up for some pain..

Thanks for your explanation. I will definitely take a look on this if
I am able to figure out.

This patch seems work well with patch from Ben Greear on latest AP firmware.

----
Chun-Yeow
