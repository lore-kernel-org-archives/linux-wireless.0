Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34073 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbbGaG4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 02:56:48 -0400
Received: by wibud3 with SMTP id ud3so46431731wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 23:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1438292115-39495-3-git-send-email-filbranden@google.com>
References: <1438292115-39495-1-git-send-email-filbranden@google.com> <1438292115-39495-3-git-send-email-filbranden@google.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 31 Jul 2015 09:56:32 +0300
Message-ID: <CA+XVXfegO1SoTkxYwT7Ne6f6eFxqEJXrvzR_ZOyz=Kso4QKUyQ@mail.gmail.com> (sfid-20150731_085652_193716_B66D5AC9)
Subject: Re: [PATCH 2/2] iw: remove android-nl.c with unneeded workaround
To: Filipe Brandenburger <filbranden@google.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Elliott Hughes <enh@google.com>,
	Christopher Wiley <wiley@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 12:35 AM, Filipe Brandenburger
<filbranden@google.com> wrote:
> The workaround might have been necessary in the past, however now it
> produces the following error:
>
>   .../libnl.a(attr.o): multiple definition of 'nla_put_flag'
>   .../android-nl.o: previous definition here
>   collect2: error: ld returned 1 exit status

Since this is required by earlier versions, can't you #ifdef the code
according to version? Also for the makefile change..
