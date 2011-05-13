Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1EMLuq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 07:50:46 -0400
Date: Fri, 13 May 2011 13:50:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jorge Miguel <jmiggal@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Setting my WiFi adhoc connection in power save mode
Message-ID: <20110513115030.GB5516@redhat.com> (sfid-20110513_135049_107032_FDA55541)
References: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 12, 2011 at 07:02:23PM +0200, Jorge Miguel wrote:
> I am trying to set power save mode in my Intel 3945ABG wireless card
> under Ubuntu 10.10 - Maverick Meerkat and iwl3945 driver.
> 
> I need to set power save mode. In order to do so I tried to change
> period and timeout options of iwconfig command so that beacon period
> and ATIM window are changed.
> 
> For instance
> :~$ sudo iwconfig wlan0 power period 2
>     Error for wireless request "Set Power Management" (8B2C):
>     SET failed on device wlan0 ; Invalid argument.
> 
> As you can see I get an error. Is it because it is not supported in my
> card? Is there any way to set beacon interval and ATIM window
> parameters?

This should work until you do this in managed mode, power save is only a
infrastructure network feature. Particularly this will not work on IBSS
network  (ad-hoc mode).

Also in kernel 2.6.39, after driver split into iwlegacy, power save
is marked as not supported by driver. I wonder it was deliberate action
from Intel developers, or just IEEE80211_HW_SUPPORTS_PS is missed by
mistake. I'm going to look at this.

Stanislaw
