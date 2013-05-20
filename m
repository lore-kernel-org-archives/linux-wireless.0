Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52132 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3ETX6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 May 2013 19:58:25 -0400
Message-ID: <519AB89E.1080001@lwfinger.net> (sfid-20130521_015827_691171_C78B7397)
Date: Mon, 20 May 2013 18:58:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: backports@vger.kernel.org
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Build problem with current git repo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pulling from the git repo today and trying to do a 'make menuconfig' results in 
the following error:

finger@larrylap:~/backports/backport> make menuconfig
Makefile.real:1: versions: No such file or directory
make[1]: *** No rule to make target `versions'.  Stop.
make: *** [menuconfig] Error 2

The first line of Makefile.real contains "include versions", but that file does 
not exist. It seems as if versions has not been committed to the repo.

After I copied that file from a tarball source version, I then get the error

finger@larrylap:~/backports/backport> make menuconfig
make[2]: `mconf' is up to date.
Kconfig:27: can't open file "net/wireless/Kconfig"
make[1]: *** [menuconfig] Error 1
make: *** [menuconfig] Error 2

Larry

