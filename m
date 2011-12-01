Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1253 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab1LANJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 08:09:37 -0500
Message-ID: <4ED77C85.1050705@broadcom.com> (sfid-20111201_140941_883128_E7078C48)
Date: Thu, 1 Dec 2011 14:09:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: bcma usage in isr context
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafał,

I am doing some final testing on our brcmsmac driver, which I tinkered
to become a bcma device driver. During testing an issue popped up in the
ISR code.

Looking into the bcma read/write functions in host_pci.c I conclude that
bcma itself does not provide protection for concurrency. Am I correct in
that? How is this solved in b43?

Gr. AvS

