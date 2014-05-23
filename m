Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:44701 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaEWKpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 06:45:22 -0400
Received: by mail-ve0-f175.google.com with SMTP id jw12so5982595veb.20
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 03:45:21 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 May 2014 12:45:21 +0200
Message-ID: <CAD3NH5U3yhFe=CiKtz0-YA8s88eOdBJiua_95wyhDsaAb13NEQ@mail.gmail.com> (sfid-20140523_124554_428150_4E0945EB)
Subject: Calling function in mac80211 from another kernel module
From: Dani Camps <danicamps81@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

We are trying to implement a kernel module that calls some functions
defined in mac80211. For that we have seen that sta_info.c already has
some functions that are exported and declared in mac80211.h. For
example:

EXPORT_SYMBOL(ieee80211_sta_block_awake)

This function is declared in mac80211.h, so we include the full path
to this header in the C file of our module. However, compilation
crashes due to other header files included in mac80211.h.

Our understanding is that we should include in the Makefile of our
module the paths to the folders hosting relevant header files in
linux_backports. However, we are struggling to find what these folders
are, could anyone advise on what these folders should be? e.g. we
found backports_include but that one alone is not enough.

Thanks for your help.

Best Regards

Daniel
