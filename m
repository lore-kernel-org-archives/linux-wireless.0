Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:64201 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755929AbXEQFj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 01:39:28 -0400
Message-ID: <464BD9D4.4020909@linux.intel.com>
Date: Wed, 16 May 2007 21:28:04 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <20070516182700.912a21ed.randy.dunlap@oracle.com>
In-Reply-To: <20070516182700.912a21ed.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap wrote:
> On Wed, 16 May 2007 14:45:32 -0700 James Ketrenos wrote:
> 
>> This patch adds the iwlwifi project directory and sources needed to 
>> build the mac80211 based wireless drivers for the Intel PRO/Wireless 
>> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
>>
>> Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
>> ---
>>
>> NOTE:  The patch is 597k and can be found at:
>>
>> 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
>>
>> Patch is against wireless-dev commit-id be8662897~
> 
> 
> Some comments/review, mostly not-code-related:
...
> 3.  Indent labels: with 0 or 1 space, not with 7 spaces.
> Using 7 spaces hides them, makes them too difficult to see/find.

I can correct this with:

	sed -i -e 's,^\(.*\)default:,foo\1default:,g' \
		-e 's,^[[:space:]]*\([[:alpha:]]\+[[:alnum:]]*:\)$, \1,g' \
		-e 's,^foo\(.*\)default:,\1default:,g' origin/*.[ch]

However scripts/Lindent undoes it.  Is there a way to keep Lindent from indenting labels?  When I looked at indent's man page it only talked about case labels.

...
> 12.  36 lines end with trailing whitespace.   :( 

I must have forgotten to run Lindent on the final code.  I'll run it (or just a sed to remove the trailing whitespace) on the code before I submit the version that addresses all the comments.

...
> 15.  Limit source lines to <= 80 columns (this patch contains
> over 200 lines that are > 80 columns).
> 

Confirmed 239 instances of > 80 columns by:

	for i in *.[ch]; do 
		echo $i
		sed -e 's,\t,        ,g' $i | 
			grep -n '^.\{80\}.\+$'
	done

I thought Lindent would handle that prettily, but I guess not.  

It seems to have enforced 80-column on some lines (sticking a bunch of right justified parameters) and on others it has made things a lot worse.   

Lindent seems to have converted space-justified column alignment into tab-justified column alignment, which frequently doesn't fit in 80 columns.  For example:

          1         2         3         4         5         6         7
01234567890123456789012345678901234567890123456789012345678901234567890123456789
int param_antenna = 0;<-10spc->/* def: 0 = both antennas (use diversity) */

was changed to:

         1         2         3         4         5         6         7
01234567890123456789012345678901234567890123456789012345678901234567890123456789
int param_antenna = 0;<-  two tabs  ->/* def: 0 = both antennas (use diversity) */

Is there another tool people use besides Lindent to enforce style?
 
Thanks,
James
