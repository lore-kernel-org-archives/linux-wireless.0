Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4858 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab3ELKeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 06:34:25 -0400
Message-ID: <518F701B.2080900@broadcom.com> (sfid-20130512_123431_472460_4ADC8521)
Date: Sun, 12 May 2013 12:34:03 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "JoSH Lehan" <krellan@gmail.com>
cc: "Adrian Chadd" <adrian@freebsd.org>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and
 cfg80211
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com>
 <518DF4B1.3020706@broadcom.com> <518ECC39.9090401@gmail.com>
 <CAJ-VmonOuhBgXa3-LkspaCgAAh8Y9Jxejn-McVourzgE-ajHTw@mail.gmail.com>
In-Reply-To: <CAJ-VmonOuhBgXa3-LkspaCgAAh8Y9Jxejn-McVourzgE-ajHTw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2013 02:46 AM, Adrian Chadd wrote:
> Hi,
>
> On 11 May 2013 15:54, JoSH Lehan <krellan@gmail.com> wrote:
>
>> Thanks!  So, I'll need to maintain two sets of mac80211/cfg80211
>> modules: one for drivers that were compiled along with the kernel, and
>> another for drivers that were compiled as part of the compat-drivers
>> package.
>
> No, you or the vendor should forward port it to linux-next, then you
> can just pick up the whole driver/framework set from compat-wireless.

That is indeed the approach. So integrate your vendor provided driver 
into your local linux-next tree and create you own compat-drivers 
package using that tree (see [1]). You have to tinker the framework to 
include that driver.

Regards,
Arend

[1] 
https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers/hacking


