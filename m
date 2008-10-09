Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31954 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbYJIWRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 18:17:31 -0400
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: "lrodrigues@atheros.com" <lrodrigues@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Date: Thu, 9 Oct 2008 15:17:18 -0700
Subject: New Regulatory Domain Api.
Message-ID: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com> (sfid-20081010_001735_861801_A7ED55A0)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,
  I have been trying to implement new regulatory api for iwlwifi drivers. One of the problem we are facing
is that , when we tried to remove iwlagn driver without removing the cfg80211,and then again inserting the
same module , we cannot set the regulatory domain.  The reasons for this probably be ,as  we are just giving a pointer to
regulatory domain in regulatory_hint function which may lead to potential memory link. Cfg80211 should copy the regulatory domain
information in its own memory rather than a pointer to driver memory.


Abhijeet
