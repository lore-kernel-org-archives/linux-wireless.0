Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60574 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764294Ab3DDSGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 14:06:51 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so3045764wgh.27
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2013 11:06:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
Date: Thu, 4 Apr 2013 11:06:50 -0700
Message-ID: <CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com> (sfid-20130404_200658_203764_788012C9)
Subject: Re: AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I'm glad you're looking into this in more depth!

On 4 April 2013 08:19, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:

> I understand that ATH_BTCOEX_CFG_2_WIRE, ATH_BTACTIVE_GPIO_9280 (GPIO6 as
> per btcoex.h) and ATH_WLANACTIVE_GPIO_9280 (GPIO5 as per btcoex.h) are used.

Ok, right.

> I next started monitoring GPIO5 on oscillaoscope to see WLAN activity and I
> could see a lot of pulse trains. Next in order to simulate high priority BT
> traffic, I pulled the line GPIO6 high. But I did not see any change in WLAN
> activity as I could continue to see the pulse trains. My expectation was
> that there should not be any WLAN activity and hence no pulses. Please guide
> if I am missing anything?

Well, firstyl you need to ensure that the GPIO pin has been programmed
to be an input, and it's of the right bluetooth type. As I said
before, GPIO pins can be input, output; they can be connected via an
internal mux to a variety of "behaviours". Take a look at the gpio
configure code in ath9k to see more.

THen you need to ensure the bluetooth coexistence registers are
programmed so that btactive will correctly stomp wifi traffic.

THat's all I know for now. Sorry.



adrian
