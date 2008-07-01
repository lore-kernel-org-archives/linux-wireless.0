Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:7535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYGAKdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:33:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so568361nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 03:33:17 -0700 (PDT)
Message-ID: <f6ca9fed0807010333s61d035e0m13e2d6b81ef63a9b@mail.gmail.com> (sfid-20080701_123326_190461_47269532)
Date: Tue, 1 Jul 2008 12:33:17 +0200
From: drago01 <drago01@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Cc: "Adel Gadllah" <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <200807011227.15805.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <200807011227.15805.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 1, 2008 at 12:27 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 01 July 2008 11:55:11 Adel Gadllah wrote:
>> Hi,
>> The attached patch removes the input device dependency and replaces
>> the polldev by a timer.
>> The timer polls the device and sets the rfkill state.
>> I build tested the patch only because I don't have access to the
>> hardware, hence the RFC.
>> Can someone with the access to the hardware test and verify this?
>> If it works I will submit a similar patch for b43legacy.
>>
>> -----------------------
>> This patch removes the dependency on the input device and replaces the
>> polldev with a timer for polling the rfkill state.
>
>
> I'm pretty sure this will generate a lot of bugreports complaining that
> rfkill silently broke, as the userspace is not setup correctly.

OK, so how to proceed? Just leave the input device?
Henrique suggested that it should be removed.
