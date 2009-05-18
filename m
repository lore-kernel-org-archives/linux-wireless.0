Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:47452 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbZERWpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 18:45:22 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1980421wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 15:45:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905182007.16782@centrum.cz>
References: <4A0FEC03.9090803@centrum.cz> <43e72e890905171426xf9f483dh9d2477cebd4eab47@mail.gmail.com>
	<200905182007.16782@centrum.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 May 2009 15:45:04 -0700
Message-ID: <43e72e890905181545y1454ec11t48e52281bc12949a@mail.gmail.com>
Subject: Re: rt2x00 - wireless compat - can not load compiled rt61pci
To: trencan@centrum.cz
Cc: linux-wireless@vger.kernel.org, ic.felix@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 11:07 AM,  <trencan@centrum.cz> wrote:
> Hello,
>
> I used "search updates" in depmod.d and it works, perfect.

You want to also add the "built-in" anyway delete that file and try
todays' compat-wireless, I added a quick script to check for this and
it adds a file for you if it doesn't detect updates/ as a preference.

So

rm -rf updates/
sudo depmod -ae

modprobe -l mac80211
to check that you are seeing the old mac80211, then install the new
stuff and ensure it does it all automatically for you now.

v2.6.30-rc6-23952-g30cf869
wireless-testing latest tag:
master-2009-05-18
This is compat-release:
master-2009-05-18-1-gf28a634

  Luis
