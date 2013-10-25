Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35881 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3JYXQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 19:16:06 -0400
Received: by mail-ee0-f52.google.com with SMTP id d51so2371260eek.11
        for <linux-wireless@vger.kernel.org>; Fri, 25 Oct 2013 16:16:04 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] carl9170: new firmware for linux-firmware.git
Date: Sat, 26 Oct 2013 01:15:54 +0200
Message-ID: <1542665.mhS5oZO9DU@debian64> (sfid-20131026_011610_739410_0737C7B5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

I'm currently updating the carl9170 firmware to the latest
version (1.9.9). I've already pushed out the sources and
updated the binaries over at our wiki (for the last time,
all future update will be via linux-firmware.git).

Now, the last item on my check off list is:
[ ]     new firmware for linux-firmware.git

Last time - when this topic came up - we had a short brainstorm
about how to handle updates in the future: 
<http://marc.info/?l=linux-wireless&m=136115736909708>

So, I've now prepared some options: 

1. Reorganize carl9170 by creating a new subdirectory "carl9170"
   and move everything in it.
   * A carl9170fw-x.y.z.tar.xz with the source is generated for
     each release and placed under carl9170/source/.

   * new firmware binaries are placed in carl9170/.
     (The firmware file name will include the version e.g. 
     carl9170-1.9.9.fw, it won't clash with a previous release.)

   * A symlink from the linux-firmware.git root to the latest 
     carl9170-1.fw in the carl9170 subfolder is added/updated for
     each release.

   For a preview see: [1]
   116 files changed, 3 insertions(+), 26313 deletions(-)
   
2. Simply replace code and firmware binary
   * The code is simply dumped from the carl9170 firmware repository
     into the existing carl9170fw directory.

   * The old firmware binary "carl9170-1.fw" file is replaced by the
     new version.

   For a preview see: [2]
   70 files changed, 2479 insertions(+), 4560 deletions(-)

I would prefer to go with option 1 and move everything into a carl9170
subdirectory. This way has the advantage that we can have multiple 
firmware binaries and sources coexisting in one place. However, I'm 
also aware of the additional "space and bandwidth" cost in this case. 

Please tell me which option you like best or if it should be done
differently. I've prepared a few RFCs (see links), but once we 
settled for the process, I'll make a proper announcement + patches.

Regards

Christian

[1] <https://drive.google.com/folderview?id=0BwOU1CguSZuBdGYxVVlTWnpXSm8>
[2] <https://drive.google.com/folderview?id=0BwOU1CguSZuBT1V2V0s2Smp0UmM>
