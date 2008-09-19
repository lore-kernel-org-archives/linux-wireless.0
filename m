Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46493 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbYISSFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 14:05:36 -0400
Received: by gxk9 with SMTP id 9so1051569gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 11:05:35 -0700 (PDT)
Message-ID: <43e72e890809191105p26841666l50a4a139a7177590@mail.gmail.com> (sfid-20080919_200551_727232_69BB6929)
Date: Fri, 19 Sep 2008 11:05:35 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Can't connect to AP with hidden essid with 2.6.27-rc6
Cc: Celejar <celejar@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <48D3CFBC.6070504@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080916220904.75283811.celejar@gmail.com>
	 <48D06B9E.70307@lwfinger.net>
	 <20080918004509.23a4bdc9.celejar@gmail.com>
	 <48D1E42C.70904@lwfinger.net>
	 <20080918015202.8c5f6381.celejar@gmail.com>
	 <48D24911.80101@lwfinger.net>
	 <20080918160957.94ea063d.celejar@gmail.com>
	 <48D2D728.6070105@lwfinger.net>
	 <20080919001050.d9ed273a.celejar@gmail.com>
	 <48D3CFBC.6070504@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 9:13 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> I do not think a bisection is necessary. Your successful test of the
> old regulatory code suggests to me that there is some kind of problem
> with the CRDA database.

BTW the "old regulatory code" is actually not "old regulatory code"
but instead static regulatory definitions slapped in the kernel just
as they were before but under the new regulatory infrastructure guise.

> Luis - to fill you in, he can connect to an AP with a hidden essid
> using the old regulatory code, but not using CRDA. There seems to be
> some critical difference between them.

Thanks for bringing this up Larry.

If by old regulatory code you mean with CONFIG_WIRELESS_OLD_REGULATORY
then I would narrow the search down to testing as follows:

--- Without crda:

mv /sbin/crda /sbin/crda-foo
sudo rmmod your_driver mac80211 cfg80211
sudo modprobe your_driver

# Check channels using iw

--- With crda:
mv /sbin/crda-foo /sbin/crda
sudo rmmod your_driver mac80211 cfg80211
sudo modprobe your_driver

# check channels using iw
---

By default when CONFIG_WIRELESS_OLD_REGULATORY is set the built-in
"US" static regulatory domain is used. If crda is present though a new
regulatory domain will be updated onto the kernel, so we'll get the
new regulatory domain built by crda from the original db.txt. Without
crda present the static regulatory domain shall be used.

What frequency is the AP on?

  Luis
