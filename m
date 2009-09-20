Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4717 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbZITDrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2009 23:47:00 -0400
Message-ID: <4AB5A5A7.3020107@canonical.com>
Date: Sat, 19 Sep 2009 21:46:47 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] compat-2.6: mangle symbols for driver-select
References: <20090919205545.GA18080@bombadil.infradead.org>
In-Reply-To: <20090919205545.GA18080@bombadil.infradead.org>
Content-Type: multipart/mixed;
 boundary="------------060608070506000607090506"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060608070506000607090506
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Luis R. Rodriguez wrote:
> Today at the summit we spoke about mangling symbols for driver-slect.
> Here's a quick nasty take on this but without doing this for driver-select
> specifically just for testing. It seems to compile, but someone more motivated
> may want to test and make this apply somehow only for driver-select or perhaps
> when a -D define is used.
> 
> Reason for this is to help distributions / OEMs / ODMs who want to replace
> just *one* driver with compat-wireless.
> 

I think it would be better to generate the list of mangled symbols 
dynamically. In older Ubuntu releases (before depmod behavior was 
corrected), we have to run a 'munge' script to preface all of the 
exported symbols so that a compat-wireless driver references the 
compat-wireless protocol stack symbols. See the attached munge script 
for compat-wireless on 2.6.24. We can either do something like this for 
compat-wireless, or we could use a subset of this logic to generate the 
list of symbols contained within the '#ifdef 
CONFIG_COMPAT_WIRELESS_MANGLE' clause.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------060608070506000607090506
Content-Type: text/plain;
 name="munge"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="munge"

#!/bin/bash
#
# Isolate the compat-wireless exported symbols and munge every occurence such that
# there is no possibility of conflict with the main kernel.
#
TL=token_list
FL=file_list
SL=sed_list
TL_EXCEPTIONS=token_list_exceptions

find compat-wireless-2.6 -name "*.[ch]" > ${FL}

rm -f ${TL_EXCEPTIONS}
for i in wireless_send_event iw_handler_set_spy wireless_spy_update iw_handler_get_thrspy iw_handler_get_spy iw_handler_set_thrspy
do
	echo ${i} >> ${TL_EXCEPTIONS}
done

cat ${FL} | \
egrep -v "compat\.[ch]" |\
xargs grep -h EXPORT_SYMBOL | \
grep -v -f ${TL_EXCEPTIONS} |\
sed -e 's/^.*EXPORT_SYMBOL_GPL(//' -e 's/);//' -e 's/^.*EXPORT_SYMBOL(//' -e 's/);//' |\
sort -r | uniq > ${TL}

rm -f ${SL}
cat ${TL} | while read token
do
	echo s/${token}/cw_${token}/g >> ${SL}
done

cat ${FL} | while read f
do
	sed -i -f ${SL} "${f}"
done

rm -f ${TL} ${FL} ${SL} ${TL_EXCEPTIONS}


--------------060608070506000607090506--
