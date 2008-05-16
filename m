Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:36469 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761950AbYEPQkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 12:40:52 -0400
Received: by el-out-1112.google.com with SMTP id s27so280225ele.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 09:40:51 -0700 (PDT)
Message-ID: <69e28c910805160940x3de182cdrb1d49588ccb392d2@mail.gmail.com> (sfid-20080516_184117_600025_0FD9E760)
Date: Fri, 16 May 2008 18:40:50 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Martin Dubuc" <martind1111@gmail.com>
Subject: Re: [ipw3945-devel] Monitor mode on boot
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <7a0107ba0805160926ib7cc07er57c00054dec238e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <7a0107ba0805151404o778a09ddj522fffa3edbeec6@mail.gmail.com>
	 <69e28c910805160316q7c1b869an7fd554979ea260b8@mail.gmail.com>
	 <7a0107ba0805160627l55f53b04r69a32e1bba36ecb6@mail.gmail.com>
	 <69e28c910805160703j4fef73e8x2c357f91d4b43ea5@mail.gmail.com>
	 <20080516150824.GB6510@tuxdriver.com>
	 <7a0107ba0805160906r4bfcd09ch6e550b929e3bd21d@mail.gmail.com>
	 <69e28c910805160916o68ba2512k3aaab29d592c54ff@mail.gmail.com>
	 <7a0107ba0805160926ib7cc07er57c00054dec238e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 6:26 PM, Martin Dubuc <martind1111@gmail.com> wrote:
> My application uses some of the Wi-Fi interfaces strictly for survey
> purposes and in these cases, there is no need to connect to any access point
> on the same wmasterX. To maximize resource usage, I would like to avoid to
> have managed interface created for these interfaces.
>
> Martin

This script should do it:
#!/bin/sh
for b in $(find /sys/class/net/*/* -name phy80211 | grep -v wmaster |
sed -e 's/\/phy80211//' | sed -e 's/\/sys\/class\/net\///'); do
iw dev $b interface del
done
for a in $(iwconfig 2>&1 | grep wmaster | sed -e 's/wmaster//' | cut -b 1); do
iw dev wmaster$a interface add mon$a type monitor
ifconfig mon$a up
done

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
