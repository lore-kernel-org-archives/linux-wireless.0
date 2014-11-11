Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48937 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaKKSUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 13:20:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XoG2t-0005Jm-M5
	for linux-wireless@vger.kernel.org; Tue, 11 Nov 2014 19:20:03 +0100
Received: from 157.88.123.237 ([157.88.123.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 19:20:03 +0100
Received: from hernan.gonzalez.calderon by 157.88.123.237 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 19:20:03 +0100
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?SGVybsOhbg==?= Maximiliano
	<hernan.gonzalez.calderon@gmail.com>
Subject: 802.11p implementation 
Date: Tue, 11 Nov 2014 18:13:33 +0000 (UTC)
Message-ID: <loom.20141111T191201-523@post.gmane.org> (sfid-20141111_192011_134058_5C7BBDBA)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I am working to adapt the ath5k module to transmit in the 5850..5925GHz
range, in order to comply with IEEE 802.11p requirements. Our plan is to
liberate the code to the community as soon as we develop it. I originally
posted this in ath5k-devel mailing list, but someone suggested me to post
try here too.


I have already compiled a new regdomains database with wireless-regdb and
crda, and we are using the module in ATH5K_TEST_CHANNELS mode. The database
is now defined as follows:

(2402 - 2472 @ 40), (3, 27)
(5170 - 5250 @ 40), (3, 17)
(5250 - 5330 @ 40), (3, 20)
(5490 - 5600 @ 40), (3, 20)
(5650 - 5710 @ 40), (3, 20)
(5735 - 5835 @ 40), (3, 30)
(5835 - 5925 @ 10), (3, 30) -> For 802.11P

However, when I execute "iw wlan1 ibss join TFG 5850" it returns the -22
error number, indicating that we are using a frequency not defined.

