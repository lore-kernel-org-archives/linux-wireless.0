Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:59375 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3ALDbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 22:31:22 -0500
Received: by mail-vb0-f41.google.com with SMTP id l22so2118892vbn.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2013 19:31:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130111065701.GF13207@elgon.mountain>
References: <20130111065701.GF13207@elgon.mountain>
Date: Sat, 12 Jan 2013 05:31:21 +0200
Message-ID: <CAFtRNNzCPy3iCd-CmFfqFzmMvkBgObg432OL3CfamFTj+ipjjg@mail.gmail.com> (sfid-20130112_043127_781685_28F33CA3)
Subject: Re: ath5k: Extend get_default_sifs/slot_time
From: Nick Kossifidis <mickflemm@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/1/11 Dan Carpenter <dan.carpenter@oracle.com>:
> ath5k: Extend get_default_sifs/slot_time

Hello Dan and thanks a lot for the review !

I should probably just move

sifs = AR5K_INIT_SIFS_DEFAULT_BG;

to default: and treat AR5K_BWMODE_DEFAULT and default: the same way,
it's misleading this way + if bwmode is not set during attach (right
now it does), sifs might stay unassigned. The same problem occurs with
ath5k_hw_get_default_slottime also.

I'll post a patch as soon as i find some time to work on ath5k again,
right now I have some physics exams at uni. It works but you are right
it's ugly.

Again thanks a lot for your time :-)

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
