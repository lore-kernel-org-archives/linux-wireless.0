Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f167.google.com ([209.85.217.167]:40529 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZCMDJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:09:56 -0400
Received: by gxk11 with SMTP id 11so2568776gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:09:53 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Mar 2009 20:09:53 -0700
Message-ID: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com> (sfid-20090313_041000_289996_8EBC20D0)
Subject: Which APs to disregards from in inputting into the bss list
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do we want to ignore certain APs if we determine they are bogus? An
example is 11n APs with WEP/TKIP. Would we rather not even store then
in our bss list so that way we wont' get reports from users not being
able to connect to such APs. Other examples might be if 11n APs have
HT IEs but their lengths are not right, or if the AP is HT40 and our
regulatory domain does now allow HT40.

The benefit I see with these early checks we won't get complaints
about not being able to connect to bogus APs or APs you shouldn't be
connected to anyway.

  Luis
