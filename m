Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:62124 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932292AbdDPWhm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 18:37:42 -0400
Date: Mon, 17 Apr 2017 00:37:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-wireless@vger.kernel.org,
        Michael Thalmeier <michael.thalmeier@hale.at>
Subject: Re: [PATCH v2] NFC: pn533: use constant off-stack buffer for sending
 acks
Message-ID: <20170416223723.GA694@zurbaran.ger.intel.com> (sfid-20170417_003745_790406_473D9450)
References: <679bea0b3868e3b8fa64c7948eb7cdbfb405d514.1491450385.git.mirq-linux@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <679bea0b3868e3b8fa64c7948eb7cdbfb405d514.1491450385.git.mirq-linux@rere.qmqm.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michał,

On Thu, Apr 06, 2017 at 05:49:02AM +0200, Michał Mirosław wrote:
> fix for WARN:
> 
> usb 3-2.4.1: NFC: Exchanging data failed (error 0x13)
> llcp: nfc_llcp_recv: err -5
> llcp: nfc_llcp_symm_timer: SYMM timeout
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 26397 at .../drivers/usb/core/hcd.c:1584 usb_hcd_map_urb_for_dma+0x370/0x550
> transfer buffer not dma capable
> [...]
> Workqueue: events nfc_llcp_timeout_work [nfc]
> Call Trace:
>  ? dump_stack+0x46/0x5a
>  ? __warn+0xb9/0xe0
>  ? warn_slowpath_fmt+0x5a/0x80
>  ? usb_hcd_map_urb_for_dma+0x370/0x550
>  ? usb_hcd_submit_urb+0x2fb/0xa60
>  ? dequeue_entity+0x3f2/0xc30
>  ? pn533_usb_send_ack+0x5d/0x80 [pn533_usb]
>  ? pn533_usb_abort_cmd+0x13/0x20 [pn533_usb]
>  ? pn533_dep_link_down+0x32/0x70 [pn533]
>  ? nfc_dep_link_down+0x87/0xd0 [nfc]
> [...]
> usb 3-2.4.1: NFC: Exchanging data failed (error 0x13)
> llcp: nfc_llcp_recv: err -5
> llcp: nfc_llcp_symm_timer: SYMM timeout
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> ---
> v2:
> 	- "un-moved" other declarations
> 	- rebased against nfc-next
> ---
>  drivers/nfc/pn533/i2c.c | 2 +-
>  drivers/nfc/pn533/usb.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
