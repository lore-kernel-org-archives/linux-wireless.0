Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55699 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdJKKPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 06:15:25 -0400
Date: Wed, 11 Oct 2017 12:15:14 +0200
From: Petr Mladek <pmladek@suse.com>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chris Metcalf <cmetcalf@mellanox.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Harish Patil <harish.patil@cavium.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Julian Wiedmann <jwi@linux.vnet.ibm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Manish Chopra <manish.chopra@cavium.com>,
        Mark Gross <mark.gross@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Reed <mdr@sgi.com>, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Sebastian Reichel <sre@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        linux1394-devel@lists.sourceforge.net, linux-mips@linux-mips.org,
        linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] timer: Remove expires argument from
 __TIMER_INITIALIZER()
Message-ID: <20171011101514.GA2882@pathway.suse.cz> (sfid-20171011_121722_309122_8E6A976A)
References: <1507159627-127660-1-git-send-email-keescook@chromium.org>
 <1507159627-127660-12-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1507159627-127660-12-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 2017-10-04 16:27:05, Kees Cook wrote:
> The expires field is normally initialized during the first mod_timer()
> call. It was unused by all callers, so remove it from the macro.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/kthread.h   | 2 +-
>  include/linux/timer.h     | 5 ++---
>  include/linux/workqueue.h | 2 +-
>  3 files changed, 4 insertions(+), 5 deletions(-)

I was primary interested into the change in kthread.h. But the entire
patch is simple and looks fine:

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
