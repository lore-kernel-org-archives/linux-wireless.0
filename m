Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:54250 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506Ab2DBNT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 09:19:58 -0400
Received: by bkcjc3 with SMTP id jc3so4058381bkc.27
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 06:19:52 -0700 (PDT)
Message-ID: <1333372786.16990.67.camel@cumari> (sfid-20120402_152004_950702_79536A79)
Subject: Re: linux-firmware: pull-request wl12xx 2012-02-22 (v2)
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
Date: Mon, 02 Apr 2012 16:19:46 +0300
In-Reply-To: <1329896611.22736.104.camel@cumari>
References: <1329896611.22736.104.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

I saw that you haven't pulled my tree yet.  Is there any problem with it
or you just didn't have the time to handle it yet?

There's no big hurry, I was just wondering why it didn't go in. ;)

Cheers,
Luca.

On Wed, 2012-02-22 at 09:43 +0200, Luciano Coelho wrote: 
> Hi Ben,
> 
> I have fixed up the stuff you mentioned.  Now our LICENCE file doesn't
> have any lines number (I had to check with legal and it is okay).  I
> also added a separate patch to change the existing WHENCE info to use
> the correct format and used the new format also when adding the new
> files.
> 
> The head of the branch I want you to pull from is:
> f268e39204577a50cdaa62547278a4d069746d51.
> 
> Please let me know if there are any problems.
> 
> 
> The following changes since commit 09c949f6d3196a7199eb2c7015bfa5d34ed723b5:
> 
>   usbdux: Add usbduxsigma firmware (2012-02-19 03:42:21 +0000)
> 
> are available in the git repository at:
>   git://github.com/TI-OpenLink/firmwares.git linux-firmware
> 
> Luciano Coelho (3):
>       linux-firmware: update ti-connectivity licence
>       linux-firmware: ti-connectivity: change fw version info to new style
>       linux-firmware: ti-connectivity: update wl12xx firmwares
> 
>  LICENCE.ti-connectivity             |  175 +++++++----------------------------
>  WHENCE                              |   52 +++++++----
>  ti-connectivity/wl127x-fw-4-mr.bin  |  Bin 0 -> 260852 bytes
>  ti-connectivity/wl127x-fw-4-plt.bin |  Bin 0 -> 261892 bytes
>  ti-connectivity/wl127x-fw-4-sr.bin  |  Bin 0 -> 276684 bytes
>  ti-connectivity/wl128x-fw-4-mr.bin  |  Bin 0 -> 264904 bytes
>  ti-connectivity/wl128x-fw-4-plt.bin |  Bin 0 -> 269424 bytes
>  ti-connectivity/wl128x-fw-4-sr.bin  |  Bin 0 -> 284156 bytes
>  8 files changed, 69 insertions(+), 158 deletions(-)
>  create mode 100644 ti-connectivity/wl127x-fw-4-mr.bin
>  create mode 100644 ti-connectivity/wl127x-fw-4-plt.bin
>  create mode 100644 ti-connectivity/wl127x-fw-4-sr.bin
>  create mode 100644 ti-connectivity/wl128x-fw-4-mr.bin
>  create mode 100644 ti-connectivity/wl128x-fw-4-plt.bin
>  create mode 100644 ti-connectivity/wl128x-fw-4-sr.bin
> 
> diff --git a/LICENCE.ti-connectivity b/LICENCE.ti-connectivity
> index 085f6c7..91a1516 100644
> --- a/LICENCE.ti-connectivity
> +++ b/LICENCE.ti-connectivity
> @@ -1,151 +1,46 @@
> -Texas Instruments Incorporated
> -Technology and Software Publicly Available
> -Software (Object Code) License Agreement
> +TECHNOLOGY AND SOFTWARE PUBLICLY AVAILABLE
> +SOFTWARE LICENSE
>  
> +Copyright (c) 2011, Texas Instruments Incorporated.
>  
> -IMPORTANT - PLEASE READ THE FOLLOWING LICENSE AGREEMENT CAREFULLY. THIS IS
> -	A LEGALLY BINDING AGREEMENT.  DO NOT DOWNLOAD THE LICENSED MATERIALS
> -	UNLESS: (1) YOU ARE AUTHORIZED TO ACCEPT AND AGREE TO THE TERMS OF THIS
> -	LICENSE AGREEMENT AND (2) YOU INTEND TO ENTER INTO AND TO BE BOUND BY
> -	THE TERMS OF THIS AGREEMENT.
> +All rights reserved.
>  
> -This Software License Agreement ("Agreement") is a legal agreement between you
> -	(either an individual or entity) and Texas Instruments Incorporated
> -	("TI").  The "Licensed Materials" subject to this Agreement include,
> -	in whole or in part, the software programs that accompany this Agreement
> -	and any "on-line" or electronic documentation associated with these
> -	programs.  By installing, copying or otherwise using the Licensed
> -	Materials you agree to abide by the terms of this Agreement.
> -	If you choose not to accept or agree with these terms, do not download
> -	or install the Licensed Materials.
> +Redistribution.
>  
> +Redistribution and use in binary form, without modification, are
> +permitted provided that the following conditions are met:
>  
> -1. Object Code License.  TI hereby grants to you a limited, non-exclusive
> -	license to reproduce and use the Licensed Materials provided to you in
> -	object code format and to distribute an unlimited number of object or
> -	executable copies of such Licensed Materials, provided that such object
> -	or executable copies are used solely and exclusively on devices
> -	manufactured by or for TI.
> + * Redistributions must preserve existing copyright notices and reproduce
> +   this license (including the above copyright notice and the disclaimer below)
> +   in the documentation and/or other materials provided with the distribution.
>  
> -2. Termination.  This license is effective until terminated.  Without prejudice
> -	to any other rights, TI may terminate your right to use the Licensed
> -	Materials under this Agreement if you fail to comply with the terms of
> -	this Agreement.  In such event, you shall destroy all copies of the
> -	Licensed Materials, including all portions and derivatives thereof.
> + * Neither the name of Texas Instruments Incorporated nor the names of
> +   its suppliers may be used to endorse or promote products derived
> +   from this software without specific prior written permission.
>  
> -3. Intellectual Property Rights.  The Licensed Materials being provided to you
> -	hereunder are being made publicly available by TI, even though they
> -	contain copyrighted material of TI and its licensors, if applicable.
> -	In no event may you alter, remove or destroy any copyright notice
> -	included in the Licensed Materials.  To the extent that any of the
> -	Licensed Materials are provided in binary or object code only, you may
> -	not unlock, decompile, reverse engineer, disassemble or otherwise
> -	translate such binary or object code to human-perceivable form. The
> -	source code of such reverse engineered code may contain TI trade secret
> -	and other proprietary information.  Further, nothing shall obligate TI
> -	to provide you with source code for the Licensed Materials licensed to
> -	you in binary or object code only under this Agreement.  TI reserves all
> -	rights not specifically granted under this Agreement.
> + * No reverse engineering, decompilation, or disassembly of this
> +   software is permitted.
>  
> -4. Warranties and Limitations.  THE LICENSED MATERIALS ARE PROVIDED "AS IS". TI
> -	MAKES NO WARRANTY OR REPRESENTATION, EXPRESS, IMPLIED OR STATUTORY,
> -	INCLUDING ANY IMPLIED WARRANTIES OF MERCHANTIBILITY, FITNESS FOR A
> -	PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR COMPLETENESS OF
> -	RESPONSES, RESULTS AND LACK OF NEGLIGENCE.  TI DISCLAIMS ANY WARRANTY OF
> -	TITLE, QUIET ENJOYMENT, QUIET POSESSION, AND NON-INFRINGEMENT OF ANY
> -	THIRD PARTY INTELLECTUAL PROPERTY RIGHTS WITH REGARD TO THE LICENSED
> -	MATERIALS OR USE OF THOSE MATERIALS.
> +Limited patent license.
>  
> -YOU ACKNOWLEDGE AND AGREE THAT THE LICENSED MATERIALS MAY NOT BE INTENDED FOR
> -	PRODUCTION APPLICATIONS AND MAY CONTAIN IRREGULARITIES AND DEFECTS NOT
> -	FOUND IN PRODUCTION SOFTWARE.  FURTHERMORE, YOU ACKNOWLEDGE AND AGREE
> -	THAT THE LICENSED MATERIALS HAVE NOT BEEN TESTED OR CERTIFIED BY ANY
> -	GOVERNMENT AGENCY OR INDUSTRY REGULATORY ORGANIZATION OR ANY OTHER THIRD
> -	PARTY ORGANIZATION.  YOU AGREE THAT PRIOR TO USING, INCORPORATING OR
> -	DISTRIBUTING THE LICENSED MATERIALS IN OR WITH ANY COMMERCIAL PRODUCT
> -	THAT YOU WILL THOROUGHLY TEST THE PRODUCT AND THE FUNCTIONALITY OF THE
> -	LICENSED MATERIALS IN OR WITH THAT PRODUCT AND BE SOLELY RESPONSIBLE FOR
> -	ANY PROBLEMS OR FAILURES.
> +Texas Instruments Incorporated grants a world-wide, royalty-free,
> +non-exclusive license under patents it now or hereafter owns or controls
> +to make, have made, use, import, offer to sell and sell ("Utilize") this
> +software, but solely to the extent that any such patent is necessary
> +to Utilize the software alone.  The patent license shall not apply to
> +any combinations which include this software.  No hardware per se is
> +licensed hereunder.
>  
> -IN NO EVENT SHALL TI, OR ANY APPLICABLE LICENSOR, BE LIABLE FOR ANY SPECIAL,
> -	INDIRECT, INCIDENTAL, PUNITIVE OR CONSEQUENTIAL DAMAGES, HOWEVER CAUSED
> -	ON ANY THEORY OF LIABILITY, ARISING IN ANY WAY OUT OF THIS AGREEMENT,
> -	OR YOUR USE OF THE LICENSED MATERIALS, WHETHER OR NOT TI HAS BEEN
> -	ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.  EXCLUDED DAMAGES INCLUDE,
> -	BUT ARE NOT LIMITED TO, COST OF REMOVAL OR REINSTALLATION, OUTSIDE
> -	COMPUTER TIME, LABOR COSTS, LOSS OR CORRUPTION OF DATA, LOSS OF
> -	GOODWILL, LOSS OF PROFITS, LOSS OF SAVINGS, OR LOSS OF USE OR
> -	INTERRUPTION OF BUSINESS OR ANY OTHER ECONOMIC LOSS.  IN NO EVENT WILL
> -	TI'S AGGREGATE LIABILITY UNDER THIS AGREEMENT OR ARISING OUT OF YOUR USE
> -	OF THE LICENSED MATERIALS EXCEED FIVE HUNDRED U.S. DOLLARS (US$500).
> -
> -Because some jurisdictions do not allow the exclusion or limitation of
> -	incidental or consequential damages or limitation on how long an implied
> -	warranty lasts, the above limitations or exclusions may not apply to
> -	you.
> -
> -5. Export Control. Thesoftware programs and any "on-line" documentation as well
> -	as any updates or upgrades to such software programs or documentation
> -	may be subject to the export or import regulations of certain countries.
> -	You agree to comply with all such regulations and acknowledge that you
> -	have the responsibility to obtain any licenses or other authorizations
> -	that may be required to export, re-export or import the Licensed
> -	Materials.
> -
> -6. Governing Law, Jurisdiction and Severability.  This Agreement will be
> -	governed by and interpreted in accordance with the laws of the State of
> -	Texas, without reference to that state's conflict of laws principles.
> -	This Agreement shall not be governed by the United Nations Convention on
> -	Contracts for the International Sale of Goods, nor shall it be governed
> -	by the Uniform Computer Information Transactions Act (UCITA).  Any
> -	dispute arising out of or related to this Agreement will be brought in,
> -	and each party consents to the exclusive jurisdiction and venue in the
> -	state and federal courts sitting in Dallas Country, Texas. Each party
> -	waives all defenses of lack of personal jurisdiction and forum
> -	non-conveniens and agrees that process may be served on either party in
> -	a manner authorized by applicable law or court rule.  If for any reason
> -	a court of competent jurisdiction finds any provision of the Agreement
> -	to be unenforceable, that provision will be enforced to the maximum
> -	extent possible to effectuate the intent of the parties and the
> -	remainder of the Agreement shall continue in full force and effect.
> -
> -7. PRC Provisions.  If you are located in the People's Republic of China ("PRC")
> -	or if the Licensed Materials will be sent to the PRC, the following
> -	provisions shall apply and shall supersede any other provisions in this
> -	Agreement concerning the same subject matter as the following
> -	provisions:
> -
> -	a.	Registration Requirements.  You shall be solely responsible for
> -	performing all acts and obtaining all approvals that may be required in
> -	connection with this Agreement by the government of the PRC, including
> -	but not limited to registering pursuant to, and otherwise complying
> -	with, the PRC Measures on the Administration of Software Products,
> -	Management Regulations on Technology Import-Export, and Technology
> -	Import and Export Contract Registration Management Rules. Upon receipt
> -	of such approvals from the government authorities, you shall forward
> -	evidence of all such approvals to TI for its records.  In the event that
> -	you fail to obtain any such approval or registration, you shall be
> -	solely responsible for any and all losses, damages or costs resulting
> -	therefrom, and shall indemnify TI for all such losses, damages or costs.
> -
> -	b.	Governing Language.  This Agreement is written and executed in
> -	the English language.  If a translation of this Agreement is required
> -	for any purpose, including but not limited to registration of the
> -	Agreement pursuant to any governmental laws, regulations or rules, you
> -	shall be solely responsible for creating such translation.  Any
> -	translation of this Agreement into a language other than English is
> -	intended solely in order to comply with such laws or for reference
> -	purposes, and the English language version shall be authoritative and
> -	controlling.
> -
> -8. Entire Agreement.  This is the entire Agreement between you and TI and
> -	supersedes any prior agreement between the parties related to the
> -	subject matter of this Agreement. No amendment or modification of this
> -	Agreement will be effective unless in writing and signed by a duly
> -	authorized representative of TI.  You hereby warrant and represent that
> -	you have obtained all authorizations and other applicable consents
> -	required empowering you to enter into this Agreement.
> -
> -1
> -TILAW-#236402v3
> +DISCLAIMER.
>  
> +THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> +"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> +LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> +A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> +OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> +SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> +LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> +DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> +THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> +(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> +OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> diff --git a/WHENCE b/WHENCE
> index 392f8c0..2999fa7 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1580,15 +1580,36 @@ Licence: Redistributable. See LICENCE.tda7706-firmware.txt for details.
>  Driver: wl12xx - Texas Instruments 802.11 wireless LAN driver
>  
>  File: wl1271-fw.bin
> +Version: 6.1.0.50.350 (STA-only)
>  File: wl1271-fw-2.bin
> +Version: 6.1.5.50.74 (STA-only)
>  File: wl1271-fw-ap.bin
> +Version: 6.2.1.0.54 (AP-only)
>  File: wl127x-fw-3.bin
> +Version: 6.3.0.0.77
>  File: wl127x-fw-plt-3.bin
> +Version: 6.3.0.0.77 (PLT-only)
> +File: wl127x-fw-4-sr.bin
> +Version: 6.3.5.0.98 (Single-role)
> +File: wl127x-fw-4-mr.bin
> +Version: 6.5.2.0.15 (Multi-role)
> +File: wl127x-fw-4-plt.bin
> +Version: 6.3.5.0.98 (PLT-only)
>  
>  File: wl128x-fw.bin
> +Version: 7.1.5.50.74 (STA-only)
>  File: wl128x-fw-ap.bin
> +Version: 7.2.1.0.54 (AP-only)
>  File: wl128x-fw-3.bin
> +Version: 7.3.0.0.77
>  File: wl128x-fw-plt-3.bin
> +Version: 7.3.0.0.77
> +File: wl128x-fw-4-sr.bin
> +Version: 7.3.5.0.98 (Single-role)
> +File: wl128x-fw-4-mr.bin
> +Version: 7.5.2.0.15 (Multi-role)
> +File: wl128x-fw-4-plt.bin
> +Version: 7.3.5.0.98 (PLT)
>  
>  File: wl127x-nvs.bin
>  File: wl128x-nvs.bin
> @@ -1598,28 +1619,23 @@ sl:   wl1271-nvs.bin -> wl127x-nvs.bin
>  
>  Licence: See LICENCE.ti-connectivity for details.
>  
> -	Station:      wl1271-fw.bin version 6.1.0.50.350
> -	Station:      wl1271-fw-2.bin version 6.1.5.50.74
> -	Station:      wl128x-fw.bin version 7.1.5.50.74
> -	Access Point: wl1271-fw-ap.bin version 6.2.1.0.54
> -	Access Point: wl128x-fw-ap.bin version 7.2.1.0.54
> -	Station & Access Point: wl127x-fw-3.bin version Rev 6.3.0.0.77
> -	PLT: 			wl127x-fw-3.bin version PLT 6.3.0.0.77
> -	Station & Access Point: wl128x-fw-3.bin version Rev 7.3.0.0.77
> -	PLT:			wl128x-fw-3.bin version PLT 7.3.0.0.77
> -
> -The nvs file includes two parts:
> +The NVS file includes two parts:
>  	 - radio calibration
> -	 - ini setting parameters
> +	 - HW configuration parameters (aka. INI values)
>  
> -In order to have correct NVS file for your device NVS tool should be use:
> -http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator
> +The published NVS files are for testing only.  Every device needs to
> +hava a unique NVS which is properly calibrated for best results.  You
> +can find more information about NVS generation for your device here:
>  
> -Example NVS files (not optimal) for wl127x and wl128x includes.
> -To use example NVS set symbolic link wl12xx-nvs.bin to one of
> -them (depending the chip on the platform)
> +http://wireless.kernel.org/en/users/Drivers/wl12xx/calibrator
>  
> -In order to use that files copy ti-connectivity directory to target FS at
> +If you're using a wl127x based device, use a symbolic link called
> +wl1271-nvs.bin that links to the wl127x-nvs.bin file.  If you are
> +using wl128x, link to wl128x-nvs.bin instead.
> +
> +The driver expects to find the firmwares under a ti-connectivity
> +subdirectory.  So if your system looks for firmwares in /lib/firmware,
> +the firmwares for wl12xx chips must be located in
>  /lib/firmware/ti-connectivity/.
>  
>  --------------------------------------------------------------------------
> diff --git a/ti-connectivity/wl127x-fw-4-mr.bin b/ti-connectivity/wl127x-fw-4-mr.bin
> new file mode 100644
> index 0000000..6dd7f0e
> Binary files /dev/null and b/ti-connectivity/wl127x-fw-4-mr.bin differ
> diff --git a/ti-connectivity/wl127x-fw-4-plt.bin b/ti-connectivity/wl127x-fw-4-plt.bin
> new file mode 100644
> index 0000000..b3b7d78
> Binary files /dev/null and b/ti-connectivity/wl127x-fw-4-plt.bin differ
> diff --git a/ti-connectivity/wl127x-fw-4-sr.bin b/ti-connectivity/wl127x-fw-4-sr.bin
> new file mode 100644
> index 0000000..a9d8f96
> Binary files /dev/null and b/ti-connectivity/wl127x-fw-4-sr.bin differ
> diff --git a/ti-connectivity/wl128x-fw-4-mr.bin b/ti-connectivity/wl128x-fw-4-mr.bin
> new file mode 100644
> index 0000000..64ca8fa
> Binary files /dev/null and b/ti-connectivity/wl128x-fw-4-mr.bin differ
> diff --git a/ti-connectivity/wl128x-fw-4-plt.bin b/ti-connectivity/wl128x-fw-4-plt.bin
> new file mode 100644
> index 0000000..05f1317
> Binary files /dev/null and b/ti-connectivity/wl128x-fw-4-plt.bin differ
> diff --git a/ti-connectivity/wl128x-fw-4-sr.bin b/ti-connectivity/wl128x-fw-4-sr.bin
> new file mode 100644
> index 0000000..e3e1000
> Binary files /dev/null and b/ti-connectivity/wl128x-fw-4-sr.bin differ
> 
> 


