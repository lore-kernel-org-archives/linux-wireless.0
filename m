Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:32839 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbXJGJtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2007 05:49:24 -0400
Received: by py-out-1112.google.com with SMTP id u77so1813637pyb
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2007 02:49:24 -0700 (PDT)
Message-ID: <40f31dec0710070249p5ed648c8u61e8fe3768d934da@mail.gmail.com> (sfid-20071007_104938_460400_9A95225F)
Date: Sun, 7 Oct 2007 02:49:23 -0700
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/6] ath5k: Ported new initval changes from OpenBSD to ath5k
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20071006011657.GA24862@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/5, Luis R. Rodriguez <mcgrof@gmail.com>:
> Ported new initval changes from OpenBSD to ath5k to ar5212_ini[] and
> ar5212_ini_mode[].

NACK

Nothing new was introduced in OpenBSD cvs that i haven't already
included!, what have you ported ???

Settings inside inivals.c are O.K. there is no need to change them and
if you do plz maintain the style, e.g. all BB TABLE settings go
together seperately per chipset (not as part of mac initialization)
etc. I've spent a lot time cleaning ini register settings up, plz
check out that these values you are adding are not already written in
a previous step.

> This also adds an O(log(N)) bitswap for one byte
> on ath5k_hw_bitswap(), thanks to Tom from OpenBSD.

ACK it's used for modifying rf buffer settings...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
