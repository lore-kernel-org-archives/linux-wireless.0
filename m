Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35472 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbEHOrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 10:47:02 -0400
Received: by wgyo15 with SMTP id o15so74794091wgy.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2015 07:47:01 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 8 May 2015 20:16:40 +0530
Message-ID: <CABPxzYKz9MK95nqzZk0=yP=UX3JvEy_JFsY5yZ3FEcOOGstBVQ@mail.gmail.com> (sfid-20150508_164706_844513_487FE58E)
Subject: Not able to set u-apsd for P2P client
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are having trouble making the uapsd working in p2p client case. Is
this broken? or is there a way to configure the uapsd for p2p client
case?


case a) p2p client with p2p_no_group_iface=1

When trying to change the mode from MANAGED to P2P_CLIENT the sdata is
being cleared so the previous change of uapsd_queue=0xF is being
cleared and default value is taken.

case b) with p2p_no_group_iface=0

As the interface is dynamically created, we cannot use the mac80211
debugfs to set the uapsd_queues.
I have tried "wpa_cli p2p_set client_apsd 1,1,1,1" but it is not taking effect.

-- 
Thanks,
Regards,
Chaitanya T K.
