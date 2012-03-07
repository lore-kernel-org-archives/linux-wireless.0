Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1297 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab2CGHqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 02:46:14 -0500
Message-ID: <4F571236.7070608@broadcom.com> (sfid-20120307_084617_660481_345BFEB8)
Date: Wed, 7 Mar 2012 08:45:58 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Rafal Milecki" <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev-list <b43-dev@lists.infradead.org>
Subject: Re: [RFC] bcma: replace ssb_sprom structure with bcma_sprom
 structure
References: <1331036818-9240-1-git-send-email-arend@broadcom.com>
 <4F569C78.90204@hauke-m.de>
In-Reply-To: <4F569C78.90204@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2012 12:23 AM, Hauke Mehrtens wrote:
> On 03/06/2012 01:26 PM, Arend van Spriel wrote:
>> BCMA shared a structure with SSB in which sprom data was stored. This
>> could have been appropriate but with upcoming srom revisions that are
>> of no interest to SSB it is better to have own definitions with BCMA.
>>
>> This patch adds support for srom revisions 8 and 9.
>
> Will sprom version 10 contain many new or different attributes so the
> struct has to be extended a lot in comparison to the changes made from
> version 8 to 9?
>

For version 10 there are only a couple of new attributes, but version 11 
is a major overhaul. Initially, I intended to have the bcma_sprom 
structure contain a union of revision specific structs, but the flat 
ssb_sprom structure made me reconsider. Looking at the current size of 
bcma_sprom I am tempted to move back to the original union solution.

>>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>> The BCMA structure is based on internal specifications. Therefor the structure
>> fields are not matching the SSB sprom structure. By dropping the use of the SSB
>> sprom structure in BCMA a fair amount of work is needed in b43 driver. If it
>> helps I can provide a mapping between bcma_sprom and ssb_sprom structure members.
> The bcm47xx architecture code will not compile with this patch either.
>
> A quick look into b43 showed that it uses the boardflags flags all other
> the code and the other stuff in most cases just in some initialization
> function of the specific phy so it should be manageable to use a
> different sprom strcut for bcma. Is there any other PHY than the N-PHY
> that is used with ssb and bcma?

I believe all AXI chips are having some flavour of N-PHY (or 11ac).

Gr. AvS

