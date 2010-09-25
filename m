Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:54619 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916Ab0IYHlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 03:41:04 -0400
Message-ID: <4C9DA78A.6080502@redfish-solutions.com>
Date: Sat, 25 Sep 2010 01:40:58 -0600
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: hauke@hauke-m.de
Subject: Breakage for 2.6.27 since August
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Going back 5 weeks, compat-wireless isn't building against 2.6.27.49:

   CC [M]  /home/philipp/kernel2/build_i586/compat-wireless-2010-08-27/compat/compat-2.6.35.o
/home/philipp/kernel2/build_i586/compat-wireless-2010-08-27/compat/compat-2.6.29.c: In function 'init_dummy_netdev':
/home/philipp/kernel2/build_i586/compat-wireless-2010-08-27/compat/compat-2.6.29.c:156: error: 'struct net_device' has no member named 'napi_list'
make[4]: *** [/home/philipp/kernel2/build_i586/compat-wireless-2010-08-27/compat/compat-2.6.29.o] Error 1
make[4]: *** Waiting for unfinished jobs....


A quick search looks like it was Hauke's patch on 8/17 entitled:

[PATCH 1/3] compat: backport init_dummy_netdev

Thanks,

-Philip


