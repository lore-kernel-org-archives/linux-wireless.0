Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40816 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZHNETT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 00:19:19 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] mmotm0812 - something in linux-next killed iwl-3945.c
References: <19728.1250182794@turing-police.cc.vt.edu>
	<20090813172819.GD2647@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 14 Aug 2009 07:19:17 +0300
In-Reply-To: <20090813172819.GD2647@tuxdriver.com> (John W. Linville's message of "Thu\, 13 Aug 2009 13\:28\:19 -0400")
Message-ID: <87zla3hvsq.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Thu, Aug 13, 2009 at 12:59:54PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> Build bombs out:
>> 
>>   CC      drivers/net/wireless/iwlwifi/iwl-3945.o
>> drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_pass_packet_to_mac80211':
>> drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)

[...]

>> Sorry, don't have a linux-next git tree, so no 'git blame' for what did it.
>> Hopefully somebody recognizes their handiwork... ;)
>
> I think this is the LEDS-related build failure, which already has a patch.

Correct. This patch fixes it:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=44f282ff0e3797555e9ac54d8a772b65f72e3702

-- 
Kalle Valo
