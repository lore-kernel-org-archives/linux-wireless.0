Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYJOVY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 17:24:56 -0400
To: wimax@linuxwimax.org, linux-wireless@vger.kernel.org
Subject: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050 v1.3
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date: Wed, 15 Oct 2008 14:22:13 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810151422.13343.inaky@linux.intel.com> (sfid-20081015_232501_591501_CE880D8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Intel would like to announce the 1.3 release of the Linux WiMAX common
stack and drivers for its WiMAX devices (eg: Intel(r) WiMAX/WiFi Link 5x50).

You can find the code and additional information at http://linuxwimax.org.

This is a maintenance release; the high level changes from release 
1.2.5 to 1.3 are:

* WiMAX network service:

 - Source tree re-structured: Removed redundant subfolders, renamed
   others and reorganize structure for clarity
	  
 - Executable names and configuration folder locations: daemon is now
   called wimaxd (from wimax_appsrvd); paths also move from
   wimax_appsrv to wimaxd (eg: /etc/wimax, /usr/share/wimax, etc).

 - WiMAX Network Service now builds and installs using automake. 
	
 - Miscellaneous bug fixes (see below for details).


* WiMAX kernel stack and drivers:

 - Miscellaneous bugs and race conditions fixes
 
   - fix the "netlink: X bytes leftover after parsing attributes."
     (requires user space protocol change)

 - Power management: USB autosuspend and base-station idle mode
   implemented. 

   - Reimplement the USB TX and RX paths so they happen in a thread;
     simplifies the implementation and allows for autosuspend to be
     active even when the device has been opened.

 - Support for SDIO interfaces enabled. Minor changes in the generic
   driver infrastructure to better fit differentr bus-glue code.

 - Use the new, IANA-approved ARPHRD_PUREIP hardware type. Requires
   changes in the DHCP client (patches available in the package and at
   the http://linuxwimax.org site).



Details:

Changes from release 1.2.5 to 1.3.3 are:

* WiMAX Network Service:*

1. Source tree re-structured
   - Number of redundant subfolders (Source/Header/Include) have been removed.
   - Some of the folder have been renamed. 
	Handlers/PipeaHandler -> messaging
	Common/Services -> Services
	AppSrv -> wimaxd
	AppSrv/L5Dispatcher -> dispatcher
	Subfolders under IPCs/Sockets have been consolidated
	L4Common/L4Bufman -> consolidated into device_dep
	WimaxUtility -> wimaxcu 
   - Some folders and files have been moved to better align with modules
   they belong to.
	OSAL --> Services/osal
	Following files under Common/ have been moved to messaging
	  - EventLogger.c|h
	  - IndicatorsSubscribers.c|h
	  - Messenger.c|h
	  - WrappersCommon.c|h
	  - WrappersUtils.c|h
	  - TraceAgent.* have been moved from AppSrv/Agents/Trace
	  
2. Executable names and configuration folder locations
   - The WiMAX Network Service daemon is now named as wimaxd (from wimax_appsrv)
   - Various configuration and library folders used by the wimaxd daemon have 
   been changed
	/etc/wimax_appsrv --> /etc/wimax
	/usr/local/lib/wimax_appsrv --> /usr/local/lib/wimax
	/var/log/wimax_appsrv --> /var/log/wimax

3. Automake build system
   - WiMAX Network Service now builds and installs using automake. 
		
4. List of bugs/issues fixed:
	
   1. Scan list not getting cleared on changing the scan mode from 
      semi-manual to manual.
   2. State continues being reported as connected after a connection 
      has dropped.
   3. Enabling HW/SW RF kill does not clear scan list.
   4. wimaxd crashes upon enabling HW RF kill after device is moved 
      to OOZ from a connected state.
   5. Scan list not getting cleared when no network is available.
   6. Mis-leading CINR,RSSI figure when signal quality changes and/or 
      device is moved to OOZ.
   7. Doing a wide scan de-stablizes the firmware and wimaxd daemon.
   8. Connect/link status and statistics not reported correctly when 
      device is in idle state.
   9. Changed cmd-line option to "update" for doing upgrades
   10. User consent is always sought prior to downloading or installing
       an update.
   11. Miscellanous segmentation faults.
   12. Un-intuitive error message when executed by un-privileged user.
   13. Improved cmd-line argument parsing.
   14. Better error reporting when HW RF is turned off during either 
       connection or scan process.


-- 
Inaky

