Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from be2.wartburg.edu ([216.159.168.186]:44043 "EHLO
	WARTBURG-EVS-01.wartburg.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753301AbYD1Bwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 21:52:34 -0400
Message-ID: <48152DDB.9050702@wartburg.edu> (sfid-20080428_035244_666132_3DD5D276)
Date: Sun, 27 Apr 2008 20:52:27 -0500
From: Charles Figura <charles.figura@wartburg.edu>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [Fwd: Re: Problems loading from compat-wireless-2008-04-24]
References: <48148E6F.3080703@wartburg.edu> <43e72e890804271418ted6360bm88f1b1f29aec6790@mail.gmail.com>
In-Reply-To: <43e72e890804271418ted6360bm88f1b1f29aec6790@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090002070304030507020107"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090002070304030507020107
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Okay, so I think I have an idea what might be going on.  I've attached
the modprobe -l for the various modules involved both after installation
and after uninstallation.  I note that after uninstallation, there are
still a few modules from the /lib/modules/2.6.24-16-generic/updates
folder.  Is this possibly due to an older self-installed compat-wireless
update?
Has monkeying around with non-apt packages goofed me up here?
If so, how can I fix it?

-C

Luis R. Rodriguez wrote:
> On Sun, Apr 27, 2008 at 7:32 AM, Charles Figura
> <charles.figura@wartburg.edu> wrote:
>> I'm running Ubuntu Hardy with the 2.6.24-16-generic kernel.
>>  I've followed the log approach laid out by Luis Rodriguez below,
>>  and attached the corresponding dmesg output.
>>
>>  As you see, the modprobe FAILS due to lots of unknown symbols.
>>
>>  Oh, one other note that I hadn't mentioned before.  I've found
>>  that a 'sudo make uninstall' doesn't get rid of the module - at
>>  least, it doesn't reset the module list.  If I follow a 'sudo make
>>  uninstall' by 'sudo modprobe iwl3945', it tries to insert the same
>>  (faulty) module.  Only by rebooting is the original restored.
>>  How do I update the module list after doing a make uninstall?
>>
>>  Thanks - hope this helps!
>>
>>
>>
>>
>>  -------- Original Message --------
>>  Subject: Re: Problems loading from compat-wireless-2008-04-24
>>  Date: Sat, 26 Apr 2008 11:14:20 -0700
>>  From: Luis R. Rodriguez <mcgrof@gmail.com>
>>  To: Charles Figura <charles.figura@wartburg.edu>
>>  References: <4810F9BC.7030104@wartburg.edu>
>> <43e72e890804252146y600b6b40x738e0826bc492b0@mail.gmail.com>
>> <4813700F.5050108@wartburg.edu>
>>
>>  On Sat, Apr 26, 2008 at 11:10 AM, Charles Figura
>>  <charles.figura@wartburg.edu> wrote:
>>
>>> Luis -
>>>
>>>  Thanks for the response.  I did, actually, do a 'make unload' before
>>>  loading the new module.  And the error I sent you was actually from
>>>  loading the single module I need - the iwl3945 module.
>>>
>>>  So I'm still back where I started, I think.
>>>
>>  Please reply to the list explaining this, Intel reads linux-wireless
>>  so they can help if its their driver.
>>
>>  Do this:
>>
>>  Reboot.
>>
>>  sudo dmesg -c > log1
>>  less log1 # review it to make sure there are no oops
>>  sudo make unload
>>  sudo dmesg -c
>>  sudo modprobe iwl4965
>>  # Try to connect or whatever to try to replicate your oops
>>  sudo dmesg -c > oops.txt
>>
>>  copy and paste the oops.txt into your e-mail, that will give a cleaner
>>  log. Also be sure to mention your kernel you are using.
>>
>>   Luis
>>
>>
>>
>>  --
>>  Charles Figura                      charles.figura@wartburg.edu
>>
>>  Associate Professor of Physics    http://mcsp.wartburg.edu/figura
>>  Director, Wartburg Platte Observatory    (319) 352-8373
>>                                          (319) 352-8606 (fax)
>>
>> [  219.046669] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_register
>>  [  219.046681] iwlwifi_mac80211: Unknown symbol wiphy_register
>>  [  219.046742] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_new
>>  [  219.046747] iwlwifi_mac80211: Unknown symbol wiphy_new
>>  [  219.047765] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_unregister
>>  [  219.047771] iwlwifi_mac80211: Unknown symbol wiphy_unregister
>>  [  219.049060] iwlwifi_mac80211: disagrees about version of symbol
>> wiphy_free
>>  [  219.049066] iwlwifi_mac80211: Unknown symbol wiphy_free
> 
> You have iwlwifi's mac8011 making the calls here. Please do after make
> install and after make uninstall:
> 
> sudo modprobe -l iwl4965
> sudo modprobe -l mac80211
> sudo modprobe -l iwlwifi_mac80211
> 
> Also inspect your /lib/modules/ directory and /lib/modules/$(uname -r)/
> 
>   Luis
> 
> 

-- 
Charles Figura                      charles.figura@wartburg.edu
Associate Professor of Physics    http://mcsp.wartburg.edu/figura
Director, Wartburg Platte Observatory    (319) 352-8373
                                          (319) 352-8606 (fax)

--------------090002070304030507020107
Content-Type: text/plain;
 name="modprobes_installed"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="modprobes_installed"

ZmlndXJhQG5pZ2h0ZmFsbDp+L2NvbXBhdC13aXJlbGVzcy0yMDA4LTA0LTI3JCBzdWRvIG1v
ZHByb2JlIC1sIGl3bDQ5NjUKL2xpYi9tb2R1bGVzLzIuNi4yNC0xNi1nZW5lcmljL3VwZGF0
ZXMvd2lyZWxlc3MvaXdsd2lmaS9pd2x3aWZpL2NvbXBhdGlibGUvaXdsNDk2NS5rbwpmaWd1
cmFAbmlnaHRmYWxsOn4vY29tcGF0LXdpcmVsZXNzLTIwMDgtMDQtMjckIHN1ZG8gbW9kcHJv
YmUgLWwgbWFjODAyMTEKL2xpYi9tb2R1bGVzLzIuNi4yNC0xNi1nZW5lcmljL3VwZGF0ZXMv
bmV0L21hYzgwMjExL21hYzgwMjExLmtvCmZpZ3VyYUBuaWdodGZhbGw6fi9jb21wYXQtd2ly
ZWxlc3MtMjAwOC0wNC0yNyQgc3VkbyBtb2Rwcm9iZSAtbCBpd2x3aWZpX21hYzgwMjExL2xp
Yi9tb2R1bGVzLzIuNi4yNC0xNi1nZW5lcmljL3VwZGF0ZXMvd2lyZWxlc3MvaXdsd2lmaS9t
YWM4MDIxMS9jb21wYXRpYmxlL25ldC9tYWM4MDIxMS9pd2x3aWZpX21hYzgwMjExLmtvCmZp
Z3VyYUBuaWdodGZhbGw6fi9jb21wYXQtd2lyZWxlc3MtMjAwOC0wNC0yNyQgICAgICAK
--------------090002070304030507020107
Content-Type: text/plain;
 name="modprobes_uninstalled"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="modprobes_uninstalled"

ZmlndXJhQG5pZ2h0ZmFsbDovbGliL21vZHVsZXMvMi42LjI0LTE2LWdlbmVyaWMkIHN1ZG8g
bW9kcHJvYmUgLWwgaXdsd2lmaV9tYWM4MDIxMQovbGliL21vZHVsZXMvMi42LjI0LTE2LWdl
bmVyaWMvdXBkYXRlcy93aXJlbGVzcy9pd2x3aWZpL21hYzgwMjExL2NvbXBhdGlibGUvbmV0
L21hYzgwMjExL2l3bHdpZmlfbWFjODAyMTEua28KZmlndXJhQG5pZ2h0ZmFsbDovbGliL21v
ZHVsZXMvMi42LjI0LTE2LWdlbmVyaWMkIHN1ZG8gbW9kcHJvYmUgLWwgbWFjODAyMTEKL2xp
Yi9tb2R1bGVzLzIuNi4yNC0xNi1nZW5lcmljL2tlcm5lbC9uZXQvbWFjODAyMTEvbWFjODAy
MTEua28KZmlndXJhQG5pZ2h0ZmFsbDovbGliL21vZHVsZXMvMi42LjI0LTE2LWdlbmVyaWMk
IHN1ZG8gbW9kcHJvYmUgLWwgaXdsNDk2NQovbGliL21vZHVsZXMvMi42LjI0LTE2LWdlbmVy
aWMvdXBkYXRlcy93aXJlbGVzcy9pd2x3aWZpL2l3bHdpZmkvY29tcGF0aWJsZS9pd2w0OTY1
LmtvCmZpZ3VyYUBuaWdodGZhbGw6L2xpYi9tb2R1bGVzLzIuNi4yNC0xNi1nZW5lcmljJCBz
dWRvIG1vZHByb2JlIC1sIGl3bDM5NDUKL2xpYi9tb2R1bGVzLzIuNi4yNC0xNi1nZW5lcmlj
L3VwZGF0ZXMvd2lyZWxlc3MvaXdsd2lmaS9pd2x3aWZpL2NvbXBhdGlibGUvaXdsMzk0NS5r
bwpmaWd1cmFAbmlnaHRmYWxsOi9saWIvbW9kdWxlcy8yLjYuMjQtMTYtZ2VuZXJpYyQK
--------------090002070304030507020107--
