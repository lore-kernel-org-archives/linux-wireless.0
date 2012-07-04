Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60540 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab2GDKKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 06:10:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SmMX8-00054k-NT
	for linux-wireless@vger.kernel.org; Wed, 04 Jul 2012 12:10:06 +0200
Received: from 2.94.91.148 ([2.94.91.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 12:10:06 +0200
Received: from scorp.dev.null by 2.94.91.148 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 12:10:06 +0200
To: linux-wireless@vger.kernel.org
From: Artem Chekunov <scorp.dev.null@gmail.com>
Subject: Re: Building and Installation errors due to modprobe -l was deprecated
Date: Wed, 4 Jul 2012 10:03:34 +0000 (UTC)
Message-ID: <loom.20120704T120059-164@post.gmane.org> (sfid-20120704_121012_759455_343EBEBC)
References: <4F58D80D.8070905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aaron <regtothismail@...> writes:

> 
> Hello,
> 
> I have problems with building and installing compat-wireless-3.3-rc1-2 
> drivers due to modprobe -l option is obsolete.
> Debian wheezy/sid
> Linux laptop 3.2.0-2-amd64 #1 SMP Sun Mar 4 22:48:17 UTC 2012 x86_64 
> GNU/Linux
> 
> # make install
> /sbin/modprobe: invalid option -- 'l'
> /sbin/modprobe: invalid option -- 'l'
> 
> Your old wireless subsystem modules were left intact:
> 
> /sbin/modprobe: invalid option -- 'l'
> make: *** [uninstall] Error 1
> 
> Best regards,
> Aaron
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Try run next
####################################################
cat > /sbin/modprobe.sh <<EOF
#!/bin/bash

if [[ \$1 == -l ]]
then

if [ -z \$2 ]    
then
find /lib/modules/\$(uname -r) -name '*.ko' | sed -e "s#\/lib\/modules\/\$(uname
-r)\/##g"
else
find /lib/modules/\$(uname -r) -name '*.ko' | sed -e "s#\/lib\/modules\/\$(uname
-r)\/##g" | grep \$2
fi

else
/sbin/modprobe \$@
fi
EOF

chmod +x /sbin/modprobe.sh
alias modprobe=/sbin/modprobe.sh
echo "alias modprobe=/sbin/modprobe.sh" >> /etc/bash.bashrc

cp Makefile Makefile.save
sed -i -e 's/^MODPROBE.*/MODPROBE := \/sbin\/modprobe.sh/g' Makefile


