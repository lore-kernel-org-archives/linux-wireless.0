Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44034 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2LJGjy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 01:39:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Thx23-0006XI-VX
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2012 07:40:04 +0100
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 07:40:03 +0100
Received: from qca_vkondrat by 212.199.104.198.static.012.net.il with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 07:40:03 +0100
To: linux-wireless@vger.kernel.org
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
Date: Thu, 6 Dec 2012 15:22:36 +0000 (UTC)
Message-ID: <loom.20121206T161917-497@post.gmane.org> (sfid-20121210_073959_449549_454E5F27)
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com> <87a9ts4c1q.fsf@nemi.mork.no> <50BF8C18.9060504@candelatech.com> <20121206122528.GG2502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@...> writes:

> We should probably assing ethtool_ops before wireless core will
> call alloc_netdev.

Another option (I verified - it works) - set in the driver

ndev->ethtool_ops = NULL;

before register_netdev(ndev);



