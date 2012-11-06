Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:60896 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2KFWJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 17:09:43 -0500
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id udSPCZ8uiLqyC6Ii (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2012 17:09:41 -0500 (EST)
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: linux 802.11s mesh should process GANN IE for interoperability
Date: Tue, 6 Nov 2012 22:09:40 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10ABC@RockMX01.rock.corp> (sfid-20121106_230954_745017_D7C6D114)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11s says gate announcement can be done in 3 ways.
1. proactive PREQ with gate bit set.
2. RANN with gate bit set.
3. GANN

Linux mac80211 chooses to ride on RANN, which is fine.
But, on receiving side, it should process GANN IE because other vendor may choose to use GANN way.

At this point (as of kernel 3.6.6). GANN IE is ignored 
In both  ieee80211_parse_elems_crc() and mesh_rx_path_sel_frame()
