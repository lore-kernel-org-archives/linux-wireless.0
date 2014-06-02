Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaFBNI0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 09:08:26 -0400
Date: Mon, 2 Jun 2014 15:06:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Michael Braun <michael-dev@fami-braun.de>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	netdev@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rt2800usb:fix efuse detection
Message-ID: <20140602130631.GA1632@redhat.com> (sfid-20140602_150845_562920_047E4F1C)
References: <20140601174736.7980.18330.stgit@charlie.fem.tu-ilmenau.de>
 <20140601175247.7980.2461.stgit@charlie.fem.tu-ilmenau.de>
 <538B79A3.1080104@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <538B79A3.1080104@cogentembedded.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 01, 2014 at 11:06:11PM +0400, Sergei Shtylyov wrote:
> >+	rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
> >+				 USB_VENDOR_REQUEST_IN, 0, 0x11, &fwMode,
> >+				 sizeof(fwMode), REGISTER_TIMEOUT_FIRMWARE);
> >+
> >+	if ((fwMode & 0x00000003) == 2)
> 
>    Operating directly on '__le32'? That doesn't look right.

rt2x00usb_register_read() helper can be used to do conversion. I also
dislike using 0x11 number instead of register name and prefer kernel
like variable names (i.e. fw_mode instead of fwMode).

Thanks
Stanislaw
