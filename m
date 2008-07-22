Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:55484 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYGVWZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 18:25:21 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2435678wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 15:25:20 -0700 (PDT)
Message-ID: <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com> (sfid-20080723_002526_772720_1108586C)
Date: Tue, 22 Jul 2008 23:25:20 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200807221613.34434.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <3ace41890807191739t5969f38au170e4b73a3d0b7de@mail.gmail.com>
	 <4882A910.4040408@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 22, 2008 at 8:13 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
<snipped>
> I got some time to take at a look at it again, I did the bisect and found
> commit 8f87dd7e540d455f8e7f11478133b85edc969c67 ("mac80211: power management
> wext hooks") to cause the issue here (non working interface). But with it,
> making "iwconfig wlan* power off" and making interface go up again, it starts
> to work. May be something related to the power management needs to be
> implemented in driver now? or keep it disabled with rtl8187...

Disabling power management doesn't improve the situation with latest
wireless testing
for me. I had a look at the change and it seems simple enough.

The latest vendor driver has a lot of suspend/resume code in it. I
have had a go at
trying to get it running against a current kernel. modprobe works but
ifconfig up results in a lot

rtl8187: EE:cannot submit RX command. URB_STATUS 0

Hin-Tak
