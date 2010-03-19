Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56342 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0CSIb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 04:31:26 -0400
Received: by wwe15 with SMTP id 15so1647519wwe.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 01:31:24 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1268961358.18314.43.camel@localhost>
References: <20100318200535.5639.6476.reportbug@bowmore>
	 <1268961358.18314.43.camel@localhost>
Date: Fri, 19 Mar 2010 09:31:24 +0100
Message-ID: <2d0a357f1003190131s447476c2o250b7ad26ee213d3@mail.gmail.com>
Subject: Re: Bug#574526: linux-image-2.6.32-4-amd64: iwlagn flood in dmesg:
	free more than tfds_in_queue
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Cyril Brulebois <kibi@debian.org>, 574526@bugs.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

there is patch pending in wireless-2.6 master GIT branch [1]:

commit c8406ea8fa1adde8dc5400127281d497bbcdb84a
"iwlwifi: Silence tfds_in_queue message"

Also, it would be fine to see "[2.6.32] iwlwifi: fix nfreed--" in
debian's 2.6.32 kernel.

Kind Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git
[2] https://patchwork.kernel.org/patch/86722/

On Fri, Mar 19, 2010 at 2:15 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Thu, 2010-03-18 at 21:05 +0100, Cyril Brulebois wrote:
>> Package: linux-2.6
>> Version: 2.6.32-10
>> Severity: normal
>>
>> Hi,
>>
>> it looks like the following upstream commits lead to those repeated
>> messages, as soon as there's some traffic on the wireless network:
>> | [ 3538.284491] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
>> | [ 3538.285838] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
>> | [ 3538.286666] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
>> | [ 3538.298152] iwlagn 0000:02:00.0: free more than tfds_in_queue (0:2)
>> | [ 3538.299241] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
>>
>> master   : a120e912eb51e347f36c71b60a1d13af74d30e83
>> 2.6.32.y : 44af042e42f2231579ea8ef7586d3789d198f609
>>
>> | $ git show v2.6.32.9-12-g44af042
>> | commit 44af042e42f2231579ea8ef7586d3789d198f609
>> | Author: Stanislaw Gruszka <sgruszka@redhat.com>
>> | Date:   Fri Feb 19 15:47:33 2010 -0800
>> |
>> |     iwlwifi: sanity check before counting number of tfds can be free
> [...]
>
> Stanislaw, do you understand how this is going wrong?  Do you have a
> fix?
>
> Ben.
>
> --
> Ben Hutchings
> If at first you don't succeed, you're doing about average.
>
