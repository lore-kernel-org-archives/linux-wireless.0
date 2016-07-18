Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34736 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGRQ77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 12:59:59 -0400
Received: by mail-qk0-f177.google.com with SMTP id o67so162869053qke.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 09:59:59 -0700 (PDT)
MIME-Version: 1.0
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Tue, 19 Jul 2016 00:59:56 +0800
Message-ID: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com> (sfid-20160718_190005_350604_714D410E)
Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> To improve that, added an 'immediate' flag to be used when the path needs to be resolved.
> Once set, a PREQ frame will be send w/o considering the MinInterval parameter.

Suggest that you try to reduce the mesh_hwmp_preq_min_interval to your
desired value instead of introducing a new patch specific to your use
case.

IEEE 802.11-2012 has defined dot11MeshHWMPpreqMinInterval attribute to
specify the minimum interval of time during which a mesh STA can send
only one Action frame containing a PREQ element. This is to avoid
flooding of broadcast PREQ frame especially when the number of mesh
STA is increased.

---
Chun-Yeow
