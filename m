Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44967 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab2KPVk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 16:40:28 -0500
Date: Sat, 17 Nov 2012 05:39:42 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [wireless-next:master 170/188]
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c:485
 brcmf_fweh_process_event() error: potential null dereference 'event'.
  (kzalloc returns null)
Message-ID: <50a6b29e.UIxFHk2yaJaNALNe%fengguang.wu@intel.com> (sfid-20121116_224031_397506_3CA0A197)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   57527f8d4d71b5167a02fb6713857f55d3974748
commit: 607d5c0ef6c4d3a2e7a61ba1b62baa0712366bc0 [170/188] brcmfmac: correct handling IF firmware event


smatch warnings:

+ drivers/net/wireless/brcm80211/brcmfmac/fweh.c:485 brcmf_fweh_process_event() error: potential null dereference 'event'.  (kzalloc returns null)

vim +485 +/event drivers/net/wireless/brcm80211/brcmfmac/fweh.c

607d5c0e Arend van Spriel 2012-11-14  469  	/* get event info */
5c36b99a Arend van Spriel 2012-11-14  470  	code = get_unaligned_be32(&event_packet->msg.event_type);
607d5c0e Arend van Spriel 2012-11-14  471  	datalen = get_unaligned_be32(&event_packet->msg.datalen);
5c36b99a Arend van Spriel 2012-11-14  472  	*ifidx = event_packet->msg.ifidx;
607d5c0e Arend van Spriel 2012-11-14  473  	data = &event_packet[1];
607d5c0e Arend van Spriel 2012-11-14  474  
607d5c0e Arend van Spriel 2012-11-14  475  	if (code != BRCMF_E_IF && !fweh->evt_handler[code]) {
607d5c0e Arend van Spriel 2012-11-14  476  		brcmf_dbg(EVENT, "event ignored: code=%d\n", code);
607d5c0e Arend van Spriel 2012-11-14  477  		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), data, datalen, "event:");
607d5c0e Arend van Spriel 2012-11-14  478  		return;
607d5c0e Arend van Spriel 2012-11-14  479  	}
607d5c0e Arend van Spriel 2012-11-14  480  
607d5c0e Arend van Spriel 2012-11-14  481  	if (in_interrupt())
607d5c0e Arend van Spriel 2012-11-14  482  		alloc_flag = GFP_ATOMIC;
607d5c0e Arend van Spriel 2012-11-14  483  
607d5c0e Arend van Spriel 2012-11-14  484  	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
607d5c0e Arend van Spriel 2012-11-14 @485  	event->code = code;
607d5c0e Arend van Spriel 2012-11-14  486  	event->ifidx = *ifidx;
607d5c0e Arend van Spriel 2012-11-14  487  
607d5c0e Arend van Spriel 2012-11-14  488  	/* use memcpy to get aligned event message */
607d5c0e Arend van Spriel 2012-11-14  489  	memcpy(&event->emsg, &event_packet->msg, sizeof(event->emsg));
607d5c0e Arend van Spriel 2012-11-14  490  	memcpy(event->data, data, datalen);
607d5c0e Arend van Spriel 2012-11-14  491  	memcpy(event->ifaddr, event_packet->eth.h_dest, ETH_ALEN);
5c36b99a Arend van Spriel 2012-11-14  492  
607d5c0e Arend van Spriel 2012-11-14  493  	brcmf_fweh_queue_event(fweh, event);

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
