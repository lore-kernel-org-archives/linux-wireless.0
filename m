Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:48783 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYHLUs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 16:48:56 -0400
Received: by nf-out-0910.google.com with SMTP id d3so945731nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 13:48:54 -0700 (PDT)
Message-ID: <48A1F734.7040801@gmail.com> (sfid-20080812_224902_685901_4B33875B)
Date: Tue, 12 Aug 2008 22:48:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: iwl + iomap + readl/writel
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I spotted that iwl drivers use readl method on an iomap space. IIRC some archs 
might return a tag instead of an address expected by readl/writel.

I think you should either switch to ioread32/iowrite32 or to ioremap.
