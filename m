Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbaGHObl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 10:31:41 -0400
From: "Stepanov, Max" <Max.Stepanov@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: mac80211: add generic cipher scheme support
Date: Tue, 8 Jul 2014 14:31:37 +0000
Message-ID: <3A934E7FDB083A4683727C7D377065951EAEA637@hasmsx109.ger.corp.intel.com> (sfid-20140708_163159_112508_EF696F7D)
References: <20140708134312.GA6538@mwanda>
In-Reply-To: <20140708134312.GA6538@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This is a semi-automatic email about new static checker warnings.
>
> The patch 2475b1cc0d52: "mac80211: add generic cipher scheme support" 
> from Mar 24, 2013, leads to the following Smatch complaint:
>
> net/mac80211/rx.c:1551 ieee80211_rx_h_decrypt()
>	 error: we previously assumed 'rx->sta' could be null (see line 1401)
> ...
>  1551			result = ieee80211_crypto_hw_decrypt(rx);
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ But if it's NULL here then we will Oops.

Thank you Dan. I'll add verification of rx->sta == NULL to ieee80211_crypto_hw_decrypt().

Max
