Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:49467 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbYEPUBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 16:01:17 -0400
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andreamrl@tiscali.it>
Subject: race between rtl8187_stop and rtl8187_rx_cb?
From: Oliver Neukum <oliver@neukum.org>
Date: Fri, 16 May 2008 22:01:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805162201.07634.oliver@neukum.org> (sfid-20080516_220123_546528_0F134D35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

rtl8187_stop() works by emptying a queue and unlinking urbs. But
an urb finishing will be taken from the queue in rtl8187_rx_cb until
it is resubmitted. Am I overlooking something or is there a window?

	Regards
		Oliver
 
