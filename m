Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:53970 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab0LVPjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 10:39:11 -0500
Received: by qyk12 with SMTP id 12so5200981qyk.12
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 07:39:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
	<AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
	<1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
	<AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
	<E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
	<AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
	<F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
Date: Wed, 22 Dec 2010 17:39:09 +0200
Message-ID: <AANLkTimzDZ0eZsfxd6JnG3YE8Ytsj1y5wGqUELFtnxes@mail.gmail.com>
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: "Kahn, Gery" <geryk@ti.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 13:30, Elvis Dowson <elvis.dowson@mac.com> wrote:

    Hi,
                     I have a quick question.

    I downloaded the
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc6-3.tar.bz2

    The information contained in this link mentions:
http://linuxwireless.org/en/users/Download/stable/

    "You need kernel headers to compile compat-wireless. Ensure
/lib/modules/$(uname -r)/build/ exists and points to the location
where the kernel headers are installed. If you do not have them, read
your distribution's documentation on getting help."

    I have Ubuntu 10.04 as host, but I'm using a cross compiler for
the OMAP3530 ARM target, and the kernel directory exists in a separate
folder.

    How do I tell the build system to use my cross compiled kernel
libraries and headers, and not pick up the host /lib/modules kernel
headers?

 export CROSS_COMPILE=arm-none-linux-gnueabi-
May be also
export ARCH=arm

    i.e. how can I cross compile and build compat-wireless for the ARM
target on the host machine?

    cd /path/to/compat-wireless-2.6.32-rc5

copy appropriate configuration file to   /path/to/compat-wireless-2.6.

    32-rc5/.config

May also need to add configuration

    ./scripts/driver-select <driver-name>
    make
    sudo make install

It may be works without `sudo '. If you want all modules also
make modules_install INSTALL_MOD_PATH=${NFSROOT}
where NFSROOT is your directory to prepare filesystem for target


    Best regards,

    Elvis Dowson

    --
    To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
    the body of a message to majordomo@vger.kernel.org
    More majordomo info at  http://vger.kernel.org/majordomo-info.html


Gery
