Return-path: <wireless-bounces@tuxdriver.com>
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V0aQHr000787	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 19:36:52 -0500
Received: by an-out-0708.google.com with SMTP id c38so27959ana	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 16:36:22 -0800 (PST)
Date: Tue, 30 Jan 2007 19:36:21 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: SIOCGIWRANGE and dscape
Sender: wireless-bounces@tuxdriver.com
To: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

Now that my link is working, and since I don't know much about the
dscape stack I'm looking for something simple to work on to get
started. I noticed that SIOCGIWRANGE is not fully implemented.

jonsmirl@jonsmirl:/extra/wireless_tools.29$ sudo iwlist wlan0 channel
wlan0     0 channels
          Current Frequency:2.412 GHz

jonsmirl@jonsmirl:/extra/wireless_tools.29$

Looking in ieee80211_ioctl.c the implementation is in
ieee80211_ioctl_giwrange().

I can work on this, but how should it be done? There is no callout
from the stack to the drivers for this IOCTL. It also doesn't make
sense that each driver have the code to build the entire channel
lists. But you do need to know whether the driver is b/g or a/b/g. How
does the driver indicate which channel domain it is in, Japan/US/EU?

Jon Smirl
jonsmirl@gmail.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
