Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34168 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1JZTDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 15:03:23 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p9QJ3MUG004031
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 12:03:23 -0700
Message-ID: <4EA8597A.50609@candelatech.com> (sfid-20111026_210325_886708_85470263)
Date: Wed, 26 Oct 2011 12:03:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: a-MSDU question (bug in debugfs?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code from net/mac80211/debugfs_sta.c appears to say that
if the IEEE80211_HT_CAP_MAX_AMSDU is set, we are at value 3839,
but elsewhere on the web it appears the opposite.

Anyone know what is correct?  I'm having no good luck finding
an official document about this...

                PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: "
                              "3839 bytes");
                 PRINT_HT_CAP(!(htc->cap & BIT(11)), "Max AMSDU length: "
                              "7935 bytes");

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

