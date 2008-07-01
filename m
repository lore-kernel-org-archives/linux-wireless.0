Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:9110 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYGAKZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:25:22 -0400
Received: by nf-out-0910.google.com with SMTP id d3so567586nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 03:25:21 -0700 (PDT)
To: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH/RFC v3] b43: remove input device usage for rfkill
Date: Tue, 1 Jul 2008 12:29:32 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>,
	stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <1214906908.7763.36.camel@johannes.berg> <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com>
In-Reply-To: <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807011229.37389.IvDoorn@gmail.com> (sfid-20080701_122527_779368_EF5E4ECF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -	/* send the radio switch event to the system - note both a key press
> -	 * and a release are required */
> -	if (unlikely(report_change)) {
> -		input_report_key(poll_dev->input, KEY_WLAN, 1);
> -		input_report_key(poll_dev->input, KEY_WLAN, 0);
> -	}

So how will b43 report the status change now? Shouldn't the above be replaced
with a call to rfkill_force_state()?

Ivo
